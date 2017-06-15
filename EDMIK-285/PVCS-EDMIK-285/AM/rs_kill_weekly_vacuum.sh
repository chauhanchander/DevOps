#!/bin/sh
#---------------------------------------#
# To kill weekly vacuum job on redshift
#
##
# By : Kamlesh Gallani
# On : May 25, 2016
#---------------------------------------#
trap "echo 'Signal Caught. Exiting' exit" SIGHUP SIGINT SIGTERM

#----Parameter Check--------------------#
if [ "$#" -ne 5 ]; then
        echo "-------------------------------------------------------------------"
        echo "Usage $0 rs_cluster rs_port rs_db rs_user rs_password"
        echo "-------------------------------------------------------------------"
        exit 1;
fi
#---------------------------------------#

LOGDIR="`grep rsdba /etc/passwd | awk -F: '{print $6}'`/logs"
ERROR_FILE="/tmp/$$_error"
LOG_FILE="${LOGDIR}/rs_kill_weeend_vacuum.log"
TEMP_DIR1=$( mktemp -d )
TODAY=`date "+%Y-%m-%d %H:%M:%S"`
MAIL='/bin/mail'
KILL=`which kill`
MAILTO="kgallani@cablevision.com"
EC2_HOST=$(grep `hostname` /etc/hosts | awk '{print $3}')


#----RS Connection Config---------------#
#source /home/kgallani/.pg_config
PSQL='/usr/bin/psql'
RS_HOST=$1
RS_HOST_PREFIX=`echo ${RS_HOST} | cut -d. -f1`
RS_PORT=$2
RS_DB=$3
RS_USER=$4
PGPASSWORD="$5"
#export PGPASSWORD=${PGPASSWORD}
PG_CON="${PSQL} -h ${RS_HOST} -p ${RS_PORT} -d ${RS_DB} -U ${RS_USER}"
#
#---------------------------------------#

msg() {
    echo "${TODAY} : $1 : $2" >> ${LOG_FILE}
}

# Function to kill vacuum on DB level
kill_on_db() {
    msg "INFO" "Check if any vacuum jobs are running on Database level"
    OUTPUT=`${PG_CON} -t -c "select * from svv_vacuum_progress where status != 'Complete'"`
    if [[ -z ${OUTPUT} ]]; then
        msg "INFO" "No VACUUM jobs in progress as of this moment. Exiting"
        exit;
    else
        msg "INFO" "VACUUM jobs running"
        msg "INFO" "`${PG_CON} -c "select * from stv_inflight where lower(trim(text)) like 'vacuum%'"`"
        msg "INFO" "Killing the above processes at DB level"
        ${PG_CON} -c "select pg_terminate_backend(pid) from stv_inflight where lower(trim(text)) like 'vacuum%'" 2>${ERROR_FILE} 1>/dev/null
        if [[ -s ${ERROR_FILE} ]]; then
            msg "ERROR" "Script aborted with error. Please check ${ERROR_FILE}"
            cat ${ERROR_FILE} | ${MAIL} -s "Redshift : Aborted - KILL_WEEKLY_VACUUM" ${MAILTO}
        fi
    fi
}

# Function to kill vacuum on OS level
kill_on_os() {
    msg "INFO" "Check if any vacuum jobs are running on OS level"
    PID=`ps -aef | grep -w "rs_vacuum_tables.sh ${RS_HOST_PREFIX}" | grep -v 'grep' | awk '{print $2}'`
    if [[ -z ${PID} ]]; then
        msg "INFO" "No Vacuum jobs running for cluster ${RS_CLUSTER} at OS level. Exiting"
        exit;
    else
        msg "INFO" "`ps -aef | grep -w "rs_vacuum_tables.sh ${RS_CLUSTER}"`"
        for p_id in ${PID}; do
            msg "INFO" "Killing process ID : ${p_id}"
            kill -9 ${p_id} 2>>${ERROR_FILE} 1>/dev/null
            ps -aef | grep ${p_id} 2>>${ERROR_FILE} 1>/dev/null
            if [[ $? -eq 0 ]]; then
                msg "INFO" "Process Id ${p_id} killed successfully"
            else
                msg "ERROR" "Error killing Process Id ${p_id}"
                cat ${ERROR_FILE} | ${MAIL} -s "Redshift : ${EC2_HOST}: kill_weekly_vaccum : Errors Reported - Please investigate" ${MAILTO}
                exit
            fi
        done
    fi
}

# Execute the functions
kill_on_db
kill_on_os


#
# End-Of-Script
#
