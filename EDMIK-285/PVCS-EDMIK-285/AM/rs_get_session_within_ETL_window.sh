#!/bin/ksh
#-----------------------------------------
# To send queries running in ETL window
# to mailiing list
#
# By : Kamlesh Gallani (DM)
# On : May 18, 2016
#
#------------------------------------------
trap "rm ${TMP_DIR};  echo 'Signal Caught. Exiting' exit" SIGHUP SIGINT SIGTERM

TODAY=`date "+%Y-%m-%d"`
TMP_DIR=$( mktemp -d )

if [[ $# -ne 7 ]]; then
        echo "Usage: $0 rs_host rs_port rs_db rs_user rs_password start_time end_time"
        echo "For e.g., sh rs_get_session_within_ETL.sh rsamp1.czfsgsdwh1wy.us-east-1.redshift.amazonaws.com  5447 cvrsamp rsadmin *** '00:00:00' '08:00:00'"
        exit 1;
fi

#source /appbisam/DBA/.pg_config
PSQL='/usr/bin/psql'
RS_HOST=$1
RS_PORT=$2
RS_DB=$3
RS_USER=$4
RS_PASSWORD=$5
START_TIME="$6"
END_TIME="$7"

export PGPASSWORD=${RS_PASSWORD}

SUBJECT="Queries within ETL window on ${TODAY}"
OUTFILE="queries_within_ETL_window_${TODAY}.csv"
MESSAGE="Hi,\n\nPlease see the attached file containing all the queries executed on redshift cluster ${RS_HOST} within ${TODAY} ${START_TIME} and ${TODAY} ${END_TIME}\n\nThanks,\nEIT DBA.\n\nP.S. This is a system generated email."
#MAIL_TO="kgallani@cablevision.com"
MAIL_TO="DWSProdMgmt@cablevision.com,yfedorch@cablevision.com,kgallani@cablevision.com"
MAIL_FROM="Kamlesh Gallani <kgallani@cablevision.com>"

QUERY="SELECT
        q.query
        ,btrim(p.usename) as username
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',q.starttime)) starttime
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',q.endtime)) as endtime
        ,btrim(DATEDIFF( second ,q.starttime,q.endtime)) as duration
        ,replace(substring(btrim(querytxt),1,200),\'\"\',\'quote\') as querytext
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',w.service_class_start_time)) as service_class_start_time
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',w.queue_start_time)) as queue_start_time
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',w.queue_end_time)) as queue_end_time
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',w.exec_start_time)) as exec_start_time
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',w.exec_end_time )) as exec_end_time
        ,btrim(CONVERT_TIMEZONE(\'America/New_York\',w.service_class_end_time)) as service_class_end_time
        ,btrim(slot_count)
        ,btrim(total_queue_time)
        ,btrim(total_exec_time)
FROM stl_query q
        INNER JOIN  pg_user p on q.userid = p.usesysid
        LEFT JOIN stl_wlm_query w ON w.query = q.query
WHERE
        -- p.usename = \'cnryusr\' AND
        (--A
        ( CONVERT_TIMEZONE(\'America/New_York\',q.starttime) >=  \'${TODAY} ${START_TIME}\' AND CONVERT_TIMEZONE(\'America/New_York\',q.starttime) <  \'${TODAY} ${END_TIME}\'  AND CONVERT_TIMEZONE(\'America/New_York\',q.endtime) >=  \'${TODAY} ${START_TIME}\' AND CONVERT_TIMEZONE(\'America/New_York\',q.endtime) <  \'${TODAY} ${END_TIME}\')

        OR
        -- B
        ( CONVERT_TIMEZONE(\'America/New_York\',q.starttime) >=  \'${TODAY} ${START_TIME}\' AND CONVERT_TIMEZONE(\'America/New_York\',q.starttime) <  \'${TODAY} ${END_TIME}\'  AND CONVERT_TIMEZONE(\'America/New_York\',q.endtime) >=  \'${TODAY} ${END_TIME}\' )

        OR
        -- C
        ( CONVERT_TIMEZONE(\'America/New_York\',q.starttime) <  \'${TODAY} ${START_TIME}\'   AND CONVERT_TIMEZONE(\'America/New_York\',q.endtime) >=  \'${TODAY} ${START_TIME}\' AND CONVERT_TIMEZONE(\'America/New_York\',q.endtime) <  \'${TODAY} ${END_TIME}\')
        OR
        -- D
        ( CONVERT_TIMEZONE(\'America/New_York\',q.starttime) <  \'${TODAY} ${START_TIME}\'   AND  CONVERT_TIMEZONE(\'America/New_York\',q.endtime) >=  \'${TODAY} ${END_TIME}\')      )
ORDER BY q.starttime,q.endtime
"
UL_QUERY="unload ('${QUERY}') to 's3://rsdba-maintenance/kgallani/test_sql.dump' credentials 'aws_access_key_id=AKIAJHFFZGPJD7S7ZT4Q;aws_secret_access_key=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' parallel off DELIMITER as ',' ADDQUOTES ALLOWOVERWRITE"

#echo $UL_QUERY

#RS_QUERY="select * from pg_user limit 10"


${PSQL} -h ${RS_HOST} -p ${RS_PORT} -d ${RS_DB} -U ${RS_USER} -c "${UL_QUERY}" 2>&1 1>/dev/null

aws s3 cp s3://rsdba-maintenance/kgallani/test_sql.dump000 ${TMP_DIR} 2>&1 1>/dev/null

mv ${TMP_DIR}/test_sql.dump000 ${TMP_DIR}/${OUTFILE}

sed -i '1s/^/query_id,username,starttime,endtime,duration,query,service_class_start_time,queue_start_time,queue_end_time,exec_start_time,exec_end_time,service_class_end_time,slot_count,total_queue_time,total_exec_time\n/' ${TMP_DIR}/${OUTFILE}

echo -e ${MESSAGE} | mailx -a "${TMP_DIR}/${OUTFILE}" -s "${SUBJECT}" -r "${MAIL_FROM}" ${MAIL_TO}

rm -rf ${TMP_DIR}
#
# End-of-Script
#
