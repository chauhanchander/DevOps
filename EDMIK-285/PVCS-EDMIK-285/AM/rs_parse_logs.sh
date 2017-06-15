#!/bin/sh
#---------------------------------------#
# To parse daily logs for RS Vaccum and Analyze
# and send email to DBA
##
# By : Kamlesh Gallani
# On : April 4, 2016
#---------------------------------------#
trap "rem_temp; echo 'Signal Caught. Exiting' exit" SIGHUP SIGINT SIGTERM

#----Parameter Check--------------------#
if [ "$#" -ne 7 ]; then
        echo "======================================================================"
        echo "Usage $0 pg_host pg_db pg_port pg_user pg_password pg_schema pg_table"
        echo "======================================================================"
        exit 1
fi
#---------------------------------------#

LOGDIR="`grep rsdba /etc/passwd | awk -F: '{print $6}'`/logs"
ERROR_FILE="/tmp/$$_error"
TEMP_FILE="/tmp/$$_temp_file"
TEMP_DIR1=$( mktemp -d )
TEMP_DIR2=$( mktemp -d )
OPT_LOG="${LOGDIR}/parseLogs.log"
TODAY=`date "+%Y-%m-%d %H:%M:%S"`
MAIL='/bin/mail'
MAILTO="kgallani@cablevision.com"
EC2_HOST=$(grep `hostname` /etc/hosts | awk '{print $3}')

#----PG Connection Config---------------#
#source /home/kgallani/.pg_config
PSQL='/usr/bin/psql'
PG_HOST=$1
PG_DB=$2
PG_PORT=$3
PG_USER=$4
PGPASSWORD="$5"
PG_SCHEMA=$6
PG_TABLE=$7
export PGPASSWORD=${PGPASSWORD}
#
#---------------------------------------#

msg() {
    echo "${TODAY} : $1 : $2" >> ${OPT_LOG}
}
rem_temp() {
        rm -rf ${TEMP_FILE} ${TEMP_DIR1} ${TEMP_DIR2}
}
main_block() {

        PG_QUERY="insert into ${PG_SCHEMA}.${PG_TABLE} (log_name,operation,job_type,cluster_name,db_name,starttime,endtime,duration,status,ec2_host) values "

        full_LOG_FILE=$1
        LOG_FILE=`basename ${full_LOG_FILE}`

        # Find operation type
        if [[ ${LOG_FILE} == *"vacuum"* ]]; then
         OPERATION="VACUUM"
        elif [[ ${LOG_FILE} == *"analyze"* ]]; then
         OPERATION="ANALYZE"
        elif [[ ${LOG_FILE} == *"backup"* ]]; then
         OPERATION="RESTORE FROM SNAPSHOT"
        else
         OPERATION="UNKNOWN"
        fi

        # Find Job type, either daily or weekly
        JOB=`[[ ${LOG_FILE} == *"daily"* ]] && echo "DAILY" || echo "WEEKLY"`

        # Find Cluster & DB name (if applicable)
        CLUSTER=`echo ${LOG_FILE} | awk -F[_.] '{print $1}'`
        [[ ${OPERATION} == "ANALYZE" || ${OPERATION} == "VACUUM" ]] && DB=`echo ${LOG_FILE}|cut -d_ -f2` || DB="NA"

        # Find timelines
        START=`grep '^\[' ${full_LOG_FILE} | head -1  | awk -F"]:" '{print $1}' | tr -d [`
        END=`grep '^\[' ${full_LOG_FILE} | tail -1 | awk -F"]:" '{print $1}' | tr -d [`
        DIFF=$(expr `date -d "${END}" +%s` - `date -d "${START}" +%s`)

        # Check for errors in log file
        egrep 'Error while executing the command|ERROR|FATAL'  ${full_LOG_FILE} > ${ERROR_FILE}
        if [[ -s ${ERROR_FILE} || ${DIFF} -le 10 ]] ; then
         msg "ERROR" "Either the Log files contain errors or operation completed within 10 seconds. Please check ${full_LOG_FILE}"
         STATUS="Failed"
        else
         STATUS="Success"
        fi

        OUTPUT="${EC2_HOST} | ${LOG_FILE} | ${OPERATION} | ${JOB} | ${CLUSTER} | ${DB} | ${START} | ${END} | ${DIFF} | ${STATUS}"

        msg "INFO" "${OUTPUT}"

        # Send output to pGSQL DB
        PG_QUERY="${PG_QUERY} ('${LOG_FILE}', '${OPERATION}', '${JOB}', '${CLUSTER}', '${DB}', '${START}', '${END}', ${DIFF}, '${STATUS}', '${EC2_HOST}')"
        ${PSQL} -h ${PG_HOST} -p ${PG_PORT} -d ${PG_DB} -U ${PG_USER} -t -c "${PG_QUERY}" 2>&1 1>/dev/null

        #-- Send mail to mailing list
        echo ${OUTPUT} | ${MAIL} -s "Daily Logs Monitor for Redshift Clusters" -r 'BIS App User <bisamusr@cvlpawsbisam1.cablevision.com>' ${MAILTO}
}


for LOG_FILE in `find ${LOGDIR}/ -type f -daystart | egrep -vi 'query_run|prm|err|txt|check|candidate|tmp|lst|parseLogs|ddl|list|canary|privileges|perf_rpt|sql|test|wlm|kill|manual'` ; do

    rm -rf ${TEMP_DIR2}/*

    # If file is a compressed tar, untar and process each subsequent file as a separate log file
    if [[ ${LOG_FILE} == *"tar.gz"* ]]; then
        cp ${LOG_FILE} ${TEMP_DIR1}
        t_log=`basename ${LOG_FILE}`
        chmod 777 ${TEMP_DIR1}/${t_log}
        tar -xzvf ${TEMP_DIR1}/${t_log} -C ${TEMP_DIR2} --strip=1 2>&1 1>/dev/null
        for log in `ls ${TEMP_DIR2}/*` ; do
            main_block ${log}
        done
    else
        # If file is a normal log file
        main_block ${LOG_FILE}
    fi
done

# Remove temp files/dirs
rem_temp

#
# End-Of-Script
#

