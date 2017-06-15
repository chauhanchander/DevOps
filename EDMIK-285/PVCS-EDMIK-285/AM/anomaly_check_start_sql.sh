#!/bin/ksh

log_date_fmt=`date +%Y%m%d`
###appwrx_dt=`date +"%Y-%m-%d"`
appwrx_dt=`TZ=America/New_York date +%Y-%m-%d`


echo $appwrx_dt

#appwrx_dt=$1

wrkdir="/appfdr/fdr/scripts/opsauto/appworx_job_anomaly"
log_dir="/appfdr/fdr/scripts/opsauto/appworx_job_anomaly"

log_file="appwrx_job_anomaly_check_start.log"

#greenplum psql client path
. /appfdr/fdr/informatica/Greenplum/greenplum-clients-4.2.2.0-build-5/greenplum_clients_path.sh
#set connection parameters

. ${wrkdir}/prm_appwrx_job_anomaly.sh

#backup previous day log 
check_curr_date=$(grep "$appwrx_dt" ${log_dir}/${log_file} | wc -l | awk -F" " ' { print $1 }')

if [ ! -f ${log_dir}/${log_file} ]
then
>${log_dir}/${log_file}
else
if [ "$check_curr_date" -eq 0 ]
then
	mv -f ${log_dir}/${log_file} ${log_dir}/${log_file}.${log_date_fmt}
	/usr/bin/gzip ${log_dir}/${log_file}.${log_date_fmt}
	>${log_dir}/${log_file}
fi
fi

#######################################################
echo "Start script date: [`date +%Y-%m-%d\ %H:%M:%S`]" 
echo "Start script date: [`date +%Y-%m-%d\ %H:%M:%S`]"  >> ${log_dir}/${log_file}
#######################################################


#  get new check ID 
check_id=$($psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "select job_anomaly.p_create_new_check('start_time','$appwrx_dt'::date);")

#  query body
$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT job_anomaly.f_build_ora_check_start_q_body('$appwrx_dt'::date)" > ${wrkdir}/temp_appwrx_qbody.sql

#  build query header
$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT job_anomaly.f_build_ora_check_start_q_header_tail(0::smallint,'$appwrx_dt'::date);" > ${wrkdir}/temp_appwrx_query_.sql


rw_q1=$(wc -l ${wrkdir}/temp_appwrx_qbody.sql |awk -F" " ' { print $1 }')
rw_q1=$(($rw_q1-1))
tail -n $rw_q1 ${wrkdir}/temp_appwrx_qbody.sql >> ${wrkdir}/temp_appwrx_query_.sql

#  build query footer
$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT job_anomaly.f_build_ora_check_start_q_header_tail(1::smallint,'$appwrx_dt'::date);" >> ${wrkdir}/temp_appwrx_query_.sql

##############################
# query to oracle appworx DB
##############################

$ORACLE_HOME/bin/sqlplus -s ${appwrx_dbuser}/${appwrx_dbpass}@${appwrx_conn} @$wrkdir/temp_appwrx_query_.sql > ${wrkdir}/tmp_appwr_start_time_chk.out

iferr=$(grep "ERROR" ${wrkdir}/tmp_appwr_start_time_chk.out | wc -l | awk -F" " ' { print $1 }')

if [ "$iferr" -eq 0 ]
then

# result transformations 

rw_q1=$(wc -l ${wrkdir}/tmp_appwr_start_time_chk.out |awk -F" " ' { print $1 }')
rw_q2=$(($rw_q1-1))

tail -n $rw_q1 ${wrkdir}/tmp_appwr_start_time_chk.out | head -n $rw_q2  > ${wrkdir}/res_appwr_start_time_chk.out

cat ${wrkdir}/res_appwr_start_time_chk.out | awk -F"," -v a_id_check=$check_id ' { print "(" a_id_check ",trim('\''" $1  "'\''),trim('\''" $2 "'\'')," $3",'\''" $4 "'\''::timestamp without time zone ,'\''" $5 "'\''::timestamp without time zone," $6 "," $7 ",trim('\''" $8 "'\''),'\''" $9 "'\''::timestamp without time zone,'\''" $10 "'\''::timestamp without time zone,'\''" $11 "'\''::timestamp without time zone,trim('\''" $12 "'\'')," $13 ")"    } '  > ${wrkdir}/tmp_values_insert_into_appwrx_start_time_check_history.out


echo "INSERT INTO job_anomaly.appwrx_start_time_check_history \
(	\
	id_check \
        ,so_parent_name \
        ,so_module \
        ,st_wd \
        ,dt_lower \
        ,dt_upper \
        ,duration_lower \
        ,duration_upper \
        ,aSO_MODULE \
        ,aSO_START_DATE \
        ,aSO_JOB_STARTED \
        ,aSO_JOB_FINISHED \
        ,aSO_STATUS_NAME \
	,chk_start_time \
) VALUES " > ${wrkdir}/tmp_insert_into_appwrx_start_time_check_history.out

i=0
while read ln
do
if [ "$i" -eq 0 ]
then
echo $ln >> ${wrkdir}/tmp_insert_into_appwrx_start_time_check_history.out
else
echo "," $ln  >> ${wrkdir}/tmp_insert_into_appwrx_start_time_check_history.out
fi
i=1
done < ${wrkdir}/tmp_values_insert_into_appwrx_start_time_check_history.out
echo ";" >> ${wrkdir}/tmp_insert_into_appwrx_start_time_check_history.out

sed 's/,'\'' '\''/,NULL/g' ${wrkdir}/tmp_insert_into_appwrx_start_time_check_history.out > ${wrkdir}/tmp_null_insert_into_appwrx_start_time_check_history.out

echo "UPDATE job_anomaly.appwrx_start_time_check_history \
SET chk_start_time_description = \
    case \
        when chk_start_time = -1 then 'not started yet' \
        when chk_start_time = 1 then 'job started in time' \
        when chk_start_time = 2 then 'job started early' \
        when chk_start_time = 3 then 'job started late' \
        when chk_start_time = 4 then 'job not started yet in time' \
        when chk_start_time = 5 then 'job not started after upper time' \
        when chk_start_time = 0 then 'null value - check monitor code' \
    end \
WHERE id_check = $check_id ;" >> ${wrkdir}/tmp_null_insert_into_appwrx_start_time_check_history.out

#insert result from appworx to postgre appworxmon
$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -f ${wrkdir}/tmp_null_insert_into_appwrx_start_time_check_history.out >> ${log_dir}/${log_file}

tail -n 2 ${log_dir}/${log_file}

#create new alert record if need
numb_new_alerts=$(psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT job_anomaly.p_create_new_alert_records($check_id);")

if [ "$numb_new_alerts" -gt 0 ]
then
    #get alerts to send
    $psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT * FROM job_anomaly.p_query_send_alert_records() ;" >${wrkdir}/tmp_start_time_new_alerts_send
    while read ln
    do
	
	alert_id=0
	module=""
	descr=""
	
	alert_id=$(echo $ln |awk -F";" ' { print $1 } ' | tr -d " ")
	module=$(echo $ln |awk -F";" ' { print $3 } ' | tr -d " ")
	descr=$(echo $ln |awk -F";" ' { print $4 } ' )
	alert_distr_list=$( echo $ln |awk -F";" ' { print $5 } ' )
	
	if [ -z "$alert_distr_list" ]
	then
	    alert_distr_list=$alert_distr_list_def
	fi
	
	#send emails to distribution list 
	
	echo "Date: [`TZ=America/New_York date +%Y-%m-%d\ %H:%M:%S`]" > ${wrkdir}/tmp_send_alert_start_time_body.out
	
	echo "module : $module" >> ${wrkdir}/tmp_send_alert_start_time_body.out
	echo "descr : $descr" >> ${wrkdir}/tmp_send_alert_start_time_body.out
	
	echo "alert_id : $alert_id" >> ${log_dir}/${log_file}
	cat ${wrkdir}/tmp_send_alert_start_time_body.out >> ${log_dir}/${log_file}
	
	cat ${wrkdir}/tmp_send_alert_start_time_body.out | mailx -s "$descr $module" ${alert_distr_list}
	
	$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT job_anomaly.f_update_appwrx_start_time_alerts(true, $alert_id );" > /dev/null
	
    done < ${wrkdir}/tmp_start_time_new_alerts_send
fi


upd_check_sql="SELECT job_anomaly.f_update_appwrx_checks(true,true,$check_id) ;"

$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "${upd_check_sql}" > /dev/null

#duration alerts 

curr_timestamp=$($psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT job_anomaly.f_curr_timestamp_dummy();")

$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT * FROM  job_anomaly.p_query_duration_send_alert_records('$curr_timestamp'::timestamp without time zone)" > ${wrkdir}/tmp_duration_new_alerts_send
    while read ln
    do
	alert_id=0
	alert_id=$(echo $ln |awk -F";" ' { print $1 } ' | tr -d " ") 
	module=$(echo $ln |awk -F";" ' { print $2 } ' | tr -d " ") 
	descr=$(echo $ln |awk -F";" ' { print $3 } ' ) 
	alert_distr_list=$( echo $ln |awk -F";" ' { print $4 } ' | tr -d " " )

	if [ -z "$alert_distr_list" ]
	then
	    alert_distr_list=$alert_distr_list_def
	fi

	
	#send emails to distribution list 
	echo "---------------------------------------" >> ${log_dir}/${log_file}
	echo "Duration alert" >> ${log_dir}/${log_file}
	
	echo "Date: [`TZ=America/New_York date +%Y-%m-%d\ %H:%M:%S`]" > ${wrkdir}/tmp_send_alert_duration_body.out
	echo "alert_id : $module" >> ${wrkdir}/tmp_send_alert_duration_body.out
	echo "descr : $descr" >> ${wrkdir}/tmp_send_alert_duration_body.out
	
	cat ${wrkdir}/tmp_send_alert_duration_body.out >> ${log_dir}/${log_file}
	
	cat ${wrkdir}/tmp_send_alert_start_time_body.out | mailx -s "$descr $module" ${alert_distr_list}
	
	$psql_bin/psql -h ${pstgr_host} -p ${pstgr_port} -U ${pstgr_usr} -w -d ${pstrg_db} -A -t -c "SELECT job_anomaly.f_update_appwrx_duration_alerts_history(true,$alert_id);" > /dev/null
    done < ${wrkdir}/tmp_duration_new_alerts_send

else
	echo "Error: oracle query error" >> ${log_dir}/${log_file} 
	grep "ERROR" ${wrkdir}/tmp_appwr_start_time_chk.out >> ${log_dir}/${log_file} 
fi	
	
rm -f ${wrkdir}/tmp_duration_new_alerts_send
rm -f ${wrkdir}/tmp_values_insert_into_appwrx_start_time_check_history.out
rm -f ${wrkdir}/tmp_insert_into_appwrx_start_time_check_history.out
rm -f ${wrkdir}/tmp_appwr_start_time_chk.out
rm -f ${wrkdir}/temp_appwrx_query_.sql
rm -f ${wrkdir}/temp_appwrx_qbody.sql
rm -f ${wrkdir}/tmp_send_alert_duration_body.out
rm -f ${wrkdir}/tmp_start_time_new_alerts_send
rm -f ${wrkdir}/tmp_send_alert_start_time_body.out
rm -f ${wrkdir}/res_appwr_start_time_chk.out
rm -f ${wrkdir}/tmp_null_insert_into_appwrx_start_time_check_history.out


echo "Script finished Date: [`date +%Y-%m-%d\ %H:%M:%S`]"
echo "Script finished Date: [`date +%Y-%m-%d\ %H:%M:%S`]" >> ${log_dir}/${log_file} 
