#!/bin/bash


##############################################
function writelog {
  echo "[`date '+%Y-%m-%d %T'`]: "$1 >> $log_dir/$logfile
  echo "[`date '+%Y-%m-%d %T'`]: "$1
}


##############################################
# This function is to send the email for the input mail_body,mail_subject and email_list
function f_sendemail {

	local l_file_attach=$1

	writelog "sending email subject: $mail_subject , email_list : $email_list"
	
	

	##if [ -n "$l_file_attach" ]
	##then
	##	echo "$mail_body" | mailx -a "$l_file_attach" -s "$mail_subject" "$email_list"
	##else
        ## 	echo "$mail_body" | mailx -s "$mail_subject" "$email_list"
	##fi 
}

##############################################
function f_abort_send_message {

################################
# abort whole script with sending email 
################################

	local l_err_msg="$1"
	writelog "$l_err_msg"
	mail_subject="${mail_msg_header} - ERROR script aborted"
	mail_body="${mail_msg_header} - ERROR script aborted - $l_err_msg , please chek log file  $log_dir/$logfile "

	f_sendemail "$log_dir/$logfile"
	exit 2
}

##############################################
# get min avilable date for cloudwatch metrics 
##############################################

function f_get_min_avialable_dtm_cloudwatch {

    local l_instanceID="$1"
    l_instanceID=$(echo $l_instanceID |tr -d " ")
    local l_v_dimension="Name=ClusterIdentifier,Value=${l_instanceID}"
    
    local l_start_dt=$(date +"%Y-%m-%dT%H:%M" -d "3 weeks ago")
    local l_end_dt=$(date +"%Y-%m-%dT%H:%M" )
    local l_c_period=86400
    
    local l_chk_dt=""
    
    $awsbinf cloudwatch get-metric-statistics --namespace "AWS/Redshift" --metric-name "CPUUtilization" --start-time ${l_start_dt} --end-time ${l_end_dt} --period $l_c_period --statistics "Average" --dimensions $l_v_dimension --output text > ${tmpfilesdir}/am_perf_metr_a_clwatch_min.tmp
    l_rc=$?
    
    if [ "$l_rc" -eq 0 ]
    then	
	cwatch_min_avilable_dtm=$(cat ${tmpfilesdir}/am_perf_metr_a_clwatch_min.tmp | awk 'NF  {  print $3 } ' | sed  '/^$/d' | sort| head -n 1)
	
	#check if date valid 
	
	l_chk_dt=$( echo $cwatch_min_avilable_dtm | cut -d\T -f1 )
	
	echo $l_chk_dt
	
	if date -d $l_chk_dt &>/dev/null
	then 
	    writelog "Retrived min avialable cloudwatch date: $cwatch_min_avilable_dtm for $l_instanceID and start_time:  ${l_start_dt} , end_date : ${l_end_dt} , period : $l_c_period "
	else 
	    f_abort_send_message "error while retrieving min avilable cloudwatch record , get $cwatch_min_avilable_dtm for instance: $l_instanceID , start_time:  ${l_start_dt} , end_date : ${l_end_dt} , period : $l_c_period ,dimension : $l_v_dimension "
	fi
	
    else
	f_abort_send_message "error while retrieving min avilable cloudwatch record for instance: $l_instanceID , start_time:  ${l_start_dt} , end_date : ${l_end_dt} , period : $l_c_period ,dimension : $l_v_dimension "
    fi

}

##############################
# get list of active instances
##############################

function f_get_list_of_redshift_resources {

	local l_q_get_active_clusters="SELECT id,instance_name \
FROM $v_histdb_DB_stat_schema.dic_instance \
WHERE is_active = true ;"

	export PGPASSWORD="$pg_password"
	 ${psqlbinf} -v ON_ERROR_STOP=1 -t -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -c "${l_q_get_active_clusters}" >> ${rs_active_clusters_list} 2>>${log_dir}/${logfile}
	 ps_query_cmd_status=$?

        if [ "$ps_query_cmd_status" -gt 0 ]
	then
        	f_abort_send_message "error while retrieving active instances list from $pg_host , port: $pg_port , db: $pg_db"
    	    cat ${rs_active_clusters_list}
	fi

}

########################################
# get list active resources and metrics
########################################

function f_get_list_active_resources_metrics {

    local l_instance_id=$1
    local l_aws_min_avilable_dtm="$2"
    local l_aws_cli_get_request_limit=$3


l_q_get_a_res_metrics="SELECT $v_histdb_DB_stat_schema.get_list_active_resources_metrics( $l_instance_id, '$l_aws_min_avilable_dtm','$aws_cli_get_request_limit' )";

    export PGPASSWORD="$pg_password"
    ${psqlbinf} -v ON_ERROR_STOP=1 -t -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -c "${l_q_get_a_res_metrics}" >> ${rs_a_res_metrics_list} 2>>${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
        f_abort_send_message "error while retrieving active instances list from $pg_host , port: $pg_port , db: $pg_db"
        cat ${rs_a_res_metrics_list}
    else
	sed -i 's/[()"]//g' ${rs_a_res_metrics_list}
	sed -i 's/,/|/g' ${rs_a_res_metrics_list}
    fi



}


function f_get_list_active_resources_sys_catalog {

    local l_instance_id=$1
    local l_q_get_active_sys_catalog="SELECT $v_histdb_DB_stat_schema.get_list_active_resources_sys_catalog( $l_instance_id )";


    export PGPASSWORD="$pg_password"
    ${psqlbinf} -v ON_ERROR_STOP=1 -t -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -c "${l_q_get_active_sys_catalog}" >> ${rs_a_funct_sys_catalog} 2>>${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
        f_abort_send_message "error while retrieving active sys catalog functiions list from $pg_host , port: $pg_port , db: $pg_db"
        cat ${rs_a_res_metrics_list}
    else
	sed -i 's/[()"]//g' ${rs_a_funct_sys_catalog}
	sed -i 's/,/|/g' ${rs_a_funct_sys_catalog}
    fi

}



function f_pg_create_new_request_record {


local lv_resource_id=$1
local l_request_parameters_str="$2"
local lv_period=$3
local lv_request_type_id=$4

local l_out_rows=0

local ltmp_new_request_id="${tmpfilesdir}/am_perf_metr_new_request_id.tmp"


    sql_new_request_id="SELECT $v_histdb_DB_stat_schema.p_create_new_request($lv_resource_id,'${l_request_parameters_str}',$lv_request_type_id,$lv_period);"


    export PGPASSWORD="$pg_password"
    ${psqlbinf} -v ON_ERROR_STOP=1 -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -c "${sql_new_request_id}" > ${ltmp_new_request_id} 2>>${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
        f_abort_send_message "error while retrieving new request id ,  $pg_host , port: $pg_port , db: $pg_db , schema : $v_histdb_DB_stat_schema"
    else
	l_out_rows=$(grep ^\([0-9][0-9]*\ row[s]*\)$ ${ltmp_new_request_id} | cut -d\( -f2 |cut -d\  -f1)
	if [ "$l_out_rows" -gt 0 ]
	then
	    v_new_request_id=$(grep -A 2 "p_create_new_request" ${ltmp_new_request_id} |tail -n 1  |tr -d " ")
	else
	    f_abort_send_message "error while retrieving new request id ,  $pg_host , port: $pg_port , db: $pg_db , schema : $v_histdb_DB_stat_schema"
	fi
    fi


}


function f_copy_cloudwatch_data_to_stage {

    local l_data_file="$1"
    local l_copy_result="${tmpfilesdir}/am_perf_metr_copy_cmd_out.tmp"

    export PGPASSWORD="$pg_password"
    cat ${l_data_file} | ${psqlbinf} -v ON_ERROR_STOP=1 -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -c "COPY $v_histdb_DB_stage_schema.stage_rsh_cloudwatch_datapoints FROM STDIN DELIMITER E'\t' NULL E'';" > ${l_copy_result} 2>>${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
	res_copy_cloudwatch_data_to_stage=1
    else
	res_copy_cloudwatch_data_to_stage=0
    fi

}


function f_update_request_status {

    local l_result_file_nm=$1
    local l_dtm="$2"
    local l_is_done="$3"
    local l_is_aborted="$4"
    local l_is_sucesfull="$5"

    l_f_upd_sql=${tmpfilesdir}/am_perf_metr_upd_request_status_sql.tmp


    echo "DROP TABLE if exists temp_cloudwatch_stage_load; \
CREATE TEMPORARY TABLE temp_cloudwatch_stage_load \
( \
    id integer \
    ,loaded_stage_records integer \
    ,is_done boolean \
    ,is_aborted boolean \
    ,is_sucesfull boolean \
); \
INSERT INTO \
temp_cloudwatch_stage_load VALUES" > $l_f_upd_sql


ddld=`awk -F" " -v v_is_done=$l_is_done -v v_is_aborted=$l_is_aborted -v v_is_successful=$l_is_sucesfull ' { if (NR==1) { print "( " $1", "$2", "v_is_done", "v_is_aborted","v_is_successful") " } else { print ",( "$1", "$2","v_is_done", "v_is_aborted", "v_is_successful") " }  }' $l_result_file_nm`

echo ${ddld}  >> $l_f_upd_sql


echo ";" >> $l_f_upd_sql

echo "UPDATE $v_histdb_DB_stat_schema.request_history rh \
SET \
    loaded_stage_records = t.loaded_stage_records \
    ,is_done = t.is_done \
    ,is_aborted = t.is_aborted \
    ,is_sucesfull = t.is_sucesfull \
FROM temp_cloudwatch_stage_load t \
WHERE rh.id = t.id; \
DROP TABLE if exists temp_cloudwatch_stage_load;" >>${l_f_upd_sql}


    export PGPASSWORD="$pg_password"
    ${psqlbinf} -v ON_ERROR_STOP=1 -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -a -f ${l_f_upd_sql} >>${log_dir}/${logfile} 2>> ${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
        f_abort_send_message "error while updating request status ,  $pg_host , port: $pg_port , db: $pg_db , schema : $v_histdb_DB_stat_schema"
    fi


}

function f_load_sys_catalog_to_stage {

    local l_active_func_list="$1"

    local l_resource_ID=0
    local l_resource_Name=""
    local l_request_function=""
    local l_request_type_id=""
    local l_request_host=""
    local l_request_port=""
    local l_request_DB=""
    local l_request_user=""
    local l_request_parameters_str=""
    local l_function_call_cmd=""

    while read l_af
    do
    
	l_resource_ID=$( echo ${l_af} | awk -F "|" ' { print $1} ' |tr -d " " )
	l_resource_Name=$( echo ${l_af} | awk -F "|" ' { print $3} ' |tr -d " " )
	l_request_function=$( echo ${l_af} | awk -F "|" ' { print $4} ' | sed 's/\-func//' )
	l_request_type_id=$( echo ${l_af} | awk -F "|" ' { print $5} ' |tr -d " " )
	l_request_host=$( echo ${l_af} | awk -F "|" ' { print $6} ' |tr -d " " )
	l_request_port=$( echo ${l_af} | awk -F "|" ' { print $7} ' |tr -d " " )
	l_request_DB=$( echo ${l_af} | awk -F "|" ' { print $8} ' |tr -d " " )
	l_request_user=$( echo ${l_af} | awk -F "|" ' { print $9} ' |tr -d " " )
	
	
	writelog "create new request_id"
	

	l_request_parameters_str="${l_request_function},host=${l_request_host},port=${l_request_port},user=${l_request_user},dbname=${l_request_DB}"
	l_request_parameters_cmd="host=${l_request_host} port=${l_request_port} user=${l_request_user} password=${rs_password} dbname=${l_request_DB}"
	
	

	f_pg_create_new_request_record $l_resource_ID "$l_request_parameters_str" 0 ${l_request_type_id}
	
	writelog "Retrieved new request id : $v_new_request_id"
	
	l_function_call_cmd="SELECT ${v_histdb_DB_stage_schema}.${l_request_function}($v_new_request_id,$l_resource_ID,0,'${l_request_parameters_cmd}');" 
	
	writelog " Start collecting sys catalog data for, resource_id: $l_resource_ID , resource_Name: $l_resource_Name , function: $l_request_type_name , request_type_id: $l_request_type_id , $l_request_parameters_str "
	export PGPASSWORD="$pg_password"
	${psqlbinf} -v ON_ERROR_STOP=1 -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -a -c "${l_function_call_cmd}" >>${log_dir}/${logfile} 2>> ${log_dir}/${logfile}
	ps_query_cmd_status=$?

	if [ "$ps_query_cmd_status" -gt 0 ]
	then
    	    f_abort_send_message "failed collecting sys catalog data for, resource_id: $l_resource_ID , resource_Name: $l_resource_Name , function: $l_request_type_name , request_type_id: $l_request_type_id , $l_request_parameters_str"
	fi
    
    done < ${l_active_func_list}

}


function f_load_from_stage_to_stat {

    local l_load_func_sql="SELECT $v_histdb_DB_stat_schema.p_load_redshift_request_statistic_daily();"


    export PGPASSWORD="$pg_password"
    ${psqlbinf} -v ON_ERROR_STOP=1 -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -a -c "${l_load_func_sql}" >>${log_dir}/${logfile} 2>> ${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
        f_abort_send_message "load from stage to stats failed $pg_host , port: $pg_port , db: $pg_db , schema : $v_histdb_DB_stat_schema"
    fi


}


function f_agg_final_queries {


    local l_agg_1="select ${v_histdb_DB_stat_schema}.p_load_new_statistic_aggr_query_hour();"

    export PGPASSWORD="$pg_password"
    ${psqlbinf} -v ON_ERROR_STOP=1 -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -a -c "${l_agg_1}" >>${log_dir}/${logfile} 2>> ${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
        f_abort_send_message "Aggregation query \" $l_agg_1 \" failed $pg_host , port: $pg_port , db: $pg_db , schema : $v_histdb_DB_stat_schema"
    fi

    local l_agg_2="select ${v_histdb_DB_stat_schema}.p_load_new_statistic_aggr_query_hour();"
    export PGPASSWORD="$pg_password"
    ${psqlbinf} -v ON_ERROR_STOP=1 -h $pg_host -p $pg_port -d $pg_db -U $pg_user -w -a -c "${l_agg_2}" >>${log_dir}/${logfile} 2>> ${log_dir}/${logfile}
    ps_query_cmd_status=$?

    if [ "$ps_query_cmd_status" -gt 0 ]
    then
        f_abort_send_message "Aggregation query \" $l_agg_2 \" failed $pg_host , port: $pg_port , db: $pg_db , schema : $v_histdb_DB_stat_schema"
    fi
 

}



###################################
## input prameters/ settings 
###################################
if [ "$#" -lt 2 ]; then

echo "======================================================================================"
echo "Usage $0 pg_db_user_password rs_cvadmin_user_password"
echo "======================================================================================"
exit 1
fi

pg_password="$1"
rs_password="$2"

# collecting period seconds
collect_period=60
collect_statistics="Maximum Minimum Sum Average SampleCount"

pg_host="pgedm1p.cicnuemrayu5.us-east-1.rds.amazonaws.com"



pg_port="5452"

pg_db="pgperfmon1"
pg_user="pgadmin"
##pg_password=""


rs_user="cvadmin"
##rs_password=""

aws_profile="default"
v_histdb_DB_stat_schema="amperfmgr"
v_histdb_DB_stage_schema="amstgmgr"

logdate=$(date +"%m%d%Y-%H%M")


tmpfilesdir="/appbisam/DBA/logs/"
awsbinf="aws --profile=$aws_profile "
aws_cli_get_request_limit=1440
psqlbinf="psql "
log_dir="/appbisam/DBA/logs/"
logfile="rs_am_rs_perf_metrics_collect.log"


email_list="yfedorch@cablevision.com"
mail_msg_header="AM Redshift Performace Metrics collect framework"

rs_active_clusters_list=${tmpfilesdir}/am_perf_metr_rs_active_clusters_list.tmp
>${tmpfilesdir}/am_perf_metr_rs_active_clusters_list.tmp

rs_a_res_metrics_list=${tmpfilesdir}/am_perf_metr_rs_a_res_metrics_list.tmp
>${rs_a_res_metrics_list}

rs_a_funct_sys_catalog=${tmpfilesdir}/am_perf_metr_rs_a_funct_sys_catalog.tmp
>$rs_a_funct_sys_catalog

am_cloudwatch_raw_data=${tmpfilesdir}/am_perf_metr_cloudwatch_raw_data.tmp
am_cloudwatch_requests_data=${tmpfilesdir}/am_perf_metr_cloudwatch_requests__data.tmp
am_cloudwatch_requests_data_err=${tmpfilesdir}/am_perf_metr_cloudwatch_requests_err.tmp
am_cloudwatch_requests_data_success=${tmpfilesdir}/am_perf_metr_cloudwatch_requests_success.tmp
am_cloudwatch_requests_ids_batch=${tmpfilesdir}/am_perf_metr_cloudwatch_requests_ids_batch.tmp


# 1 . Get List of active redshift instances 

    writelog "Get List of active redshift instances from host: $pg_host , port: $pg_port , db: $pg_db"

    f_get_list_of_redshift_resources
    sed -i '/^$/d' ${rs_active_clusters_list}

    cat ${rs_active_clusters_list} >> ${log_dir}/${logfile}

    chk_cnt_active_inst=$(wc -l ${rs_active_clusters_list}  | awk ' { print $1 } ' )


if [ "$chk_cnt_active_inst" -gt 0 ]
then
#  2. Start loop by active instances 

	writelog "Start for list of instances from ${rs_active_clusters_list} Total: $chk_cnt_active_inst active instances"

	writelog "Check and load if found for stage data not loaded to stats yet"
	f_load_from_stage_to_stat
	
	while read l_a_instances
	do
	
	    rs_instance_id=$( echo $l_a_instances |awk -F"|" ' { print $1 } ' |tr -d ' ')
	    rs_instance_name=$(  echo $l_a_instances |awk -F"|" ' { print $2 } ' |tr -d ' ' )
	    writelog "Instance Name:  $rs_instance_name"

## collect sys_catalog data
	    writelog "Retrieving list of functions for sys catalog data collection:   $rs_instance_name"
	    f_get_list_active_resources_sys_catalog $rs_instance_id

	    sed -i '/^$/d' ${rs_a_funct_sys_catalog}
	    cat ${rs_a_funct_sys_catalog} >>${log_dir}/${logfile}
	    
	    if [ "$(wc -l ${rs_a_funct_sys_catalog} | cut -d\  -f1)" -ge 1 ]
	    then  

		f_load_sys_catalog_to_stage ${rs_a_funct_sys_catalog}
	    
		writelog "Collecting sys catalog data completed for $rs_instance_name"
		
	    else
		writelog "there is no active collect sys catalog function for $rs_instance_name, skipped "
	    fi
	    
	    
# get min avialable date in Cloudwatch for instance $rs_instance_name"
	    writelog "Start get min avialable date in Cloudwatch for Instance Name:  $rs_instance_name"
	    
	    f_get_min_avialable_dtm_cloudwatch "$rs_instance_name"

# Get list of active resources
	    writelog "Get list of active resources and metrics for instance :  $rs_instance_name"
 
	    f_get_list_active_resources_metrics $rs_instance_id "$cwatch_min_avilable_dtm" $aws_cli_get_request_limit
	    
	    sed -i '/^$/d' ${rs_a_res_metrics_list}
	    
	    cat ${rs_a_res_metrics_list} >>${log_dir}/${logfile}
	    
	    chk_cnt_a_res_metrics_list=$(wc -l ${rs_a_res_metrics_list}  | awk ' { print $1 } ' )
	    
	    if [ "$chk_cnt_a_res_metrics_list" -gt 0 ]
	    then
		writelog "Start collectiong process for list of metrics from ${rs_a_res_metrics_list} , Total numbers of resorces-> metrics : $chk_cnt_a_res_metrics_list"
		
		>${am_cloudwatch_raw_data}
		>${am_cloudwatch_requests_data}
		>${am_cloudwatch_requests_data_err}
		>${am_cloudwatch_requests_data_success}
		>${am_cloudwatch_requests_ids_batch}
		
		while read ln_res_metric
		do
		    
		    
		    
		    wresource_ID=$( echo ${ln_res_metric} | awk -F "|" ' { print $1} ' |tr -d " ")
		    wresource_Name=$( echo ${ln_res_metric} | awk -F "|" ' { print $3} ' |tr -d " ")
		    
		    wdimension_name=$( echo ${ln_res_metric} | awk -F "|" ' { print $5} ' )
		    wmetric_ID=$( echo ${ln_res_metric} | awk -F "|" ' { print $6} ' |tr -d " " )
		    wmetric_Name=$( echo ${ln_res_metric} | awk -F "|" ' { print $7} ' |tr -d " " )
		    
		    wmetric_collect_start_date=$( echo ${ln_res_metric} | awk -F "|" ' { print $9} '  )
		    wmetric_collect_end_date=$( echo ${ln_res_metric} | awk -F "|" ' { print $10} '  )
		    
		    wmetric_diffmin=$( echo ${ln_res_metric} | awk -F "|" ' { print $11} '  )
		    wmetric_steps=$( echo ${ln_res_metric} | awk -F "|" ' { print $12} '  )
		    
		    wrequest_type_id=$( echo ${ln_res_metric} | awk -F "|" ' { print $13} '  )
		    
		    if [ "$wdimension_name" == "cluster" ]; then
			v_dimension_p="Name=ClusterIdentifier,Value=${rs_instance_name}"
		    fi
		    if [ "$wdimension_name" == "leader node" ]; then
			v_dimension_p="Name=NodeID,Value=Leader Name=ClusterIdentifier,Value=${rs_instance_name}"
		    fi
		    if [ "$wdimension_name" == "compute node" ]; then
			v_dimension_p="Name=NodeID,Value=${wresource_Name} Name=ClusterIdentifier,Value=${rs_instance_name}"
            	    fi
                		    
		    i=1
		    
		    wmetric_collect_start_date=$(date +"%Y-%m-%d %H:%M" -d "${wmetric_collect_start_date}")
		    
		    if [[ "$wmetric_steps" -eq 0 && "$wmetric_diffmin" -gt 0 ]]
		    then
			if [ "$wmetric_diffmin" -le 10  ]
			then
			    writelog ""
			    sleep 600
			fi
			wmetric_steps=1
		    fi
		    
		    until [ "$i" -gt "$wmetric_steps" ]
		    do
			
			if [ "$wmetric_diffmin" -ge 1440 ]
			then
			    wnext_date=$(date +"%Y-%m-%d %H:%M" -d " ${wmetric_collect_start_date} 1440 minutes")
			else
			    wnext_date=$(date +"%Y-%m-%d %H:%M" -d " ${wmetric_collect_start_date} $wmetric_diffmin minutes")
			fi
			
			run_start_time=$(echo $wmetric_collect_start_date | sed -e 's/\ /T/g')
			run_end_time=$(echo $wnext_date | sed -e 's/\ /T/g')
			
			# create new request id 
			
			wrequest_parameters_str="{start_time:$run_start_time,end_time:$run_end_time,metric_name:$wmetric_Name,dimension:$v_dimension_p,period:$collect_period}"
			
			f_pg_create_new_request_record $wresource_ID "${wrequest_parameters_str}" ${collect_period} ${wrequest_type_id}
			writelog "created new request_id $v_new_request_id"
			
			echo "$v_new_request_id 0" >> ${am_cloudwatch_requests_ids_batch}

			>$am_cloudwatch_raw_data

			writelog "Start collection process for instance :$rs_instance_id ,resourceName: $wresource_Name ,metric: $wmetric_Name ,start_dtm: $wmetric_collect_start_date, end_dtm :$wnext_date "
			writelog "aws cli command:  ${awsbinf} cloudwatch get-metric-statistics --namespace \"AWS/Redshift\" --metric-name $wmetric_Name --start-time ${run_start_time} --end-time ${run_end_time} --period ${collect_period} --statistics ${collect_statistics} --dimensions ${v_dimension_p} --output text"
			
			$awsbinf cloudwatch get-metric-statistics --namespace "AWS/Redshift" --metric-name $wmetric_Name --start-time ${run_start_time} --end-time ${run_end_time} --period ${collect_period} --statistics ${collect_statistics} --dimensions ${v_dimension_p} --output text | grep "DATAPOINTS" > $am_cloudwatch_raw_data 2>> $log_dir/$logfile
			aw_rc=$?
    
			if [ "$l_rc" -eq 0 ]
			then
				cat $am_cloudwatch_raw_data | awk -v request_id=$v_new_request_id -v resource_id=$wresource_ID -v v_metric_id=$wmetric_ID 'BEGIN { FS="\t" } { print request_id "\t" resource_id "\t" v_metric_id "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 }' >>${am_cloudwatch_requests_data}
				
				# store list of sucessfull request_id and count stage records 
				cat $am_cloudwatch_raw_data | awk -v request_id=$v_new_request_id -v resource_id=$wresource_ID -v v_metric_id=$wmetric_ID 'BEGIN { FS="\t" } { print request_id "\t" resource_id "\t" v_metric_id "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 }' |  awk '{ arr[$1]++ } END { for (a in arr) print a, arr[a]} ' | sort -k1 >> ${am_cloudwatch_requests_data_success}
			else
			    writelog "Error while running ${awsbinf} cloudwatch get-metric-statistics --namespace \"AWS/Redshift\" --metric-name $wmetric_Name --start-time ${run_start_time} --end-time ${run_end_time} --period ${collect_period} --statistics ${collect_statistics} --dimensions ${v_dimension_p} --output text"
			    echo "$v_new_request_id 0" >> $am_cloudwatch_requests_data_err
			fi
			
			i=$(( i + 1 ))
			wmetric_collect_start_date=$(date +"%Y-%m-%d %H:%M" -d " $wnext_date 1 minute")
			
		    done
		    
		    
		    
		done < ${rs_a_res_metrics_list}
		
		### Load collected data into stage tables
		cnt_rec_request_data=$( wc -l $am_cloudwatch_requests_data | cut -d\  -f1 )
		    
		if [ "$cnt_rec_request_data" -gt 0 ]
		then
		    
		    writelog "Start copy collected data from $am_cloudwatch_requests_data into $v_histdb_DB_stage_schema.stage_rsh_cloudwatch_datapoints table , Total records : $cnt_rec_request_data"
		    
		    f_copy_cloudwatch_data_to_stage $am_cloudwatch_requests_data
		    
		    dtm_load_to_stage_completed=$(date +"%Y-%m-%d %H:%M:%S")
		    
		    if [ "$res_copy_cloudwatch_data_to_stage" -eq 0 ]
		    then
			writelog "data from: $am_cloudwatch_requests_data file ,total: $cnt_rec_request_data records , loaded sucesfully to $v_histdb_DB_stage_schema.stage_rsh_cloudwatch_datapoints table"
			### update status for sucesfully loaded requests
			### finished_at is_done is_aborted is_sucesfull
			writelog "update status for successfuly loaded records " 
			f_update_request_status "${am_cloudwatch_requests_data_success}" "$dtm_load_to_stage_completed" "true" "false" "true"
			
		    else
			## update status aborted  
			### finished_at is_done is_aborted is_sucesfull
			f_update_request_status "${am_cloudwatch_requests_data_success}" "$dtm_load_to_stage_completed" "true" "true" "false"
			writelog "update status for records load was aborted - and abort whole script" 
			
			f_abort_send_message "error while loading cloudwatch data from file $l_data_file to  $v_histdb_DB_stage_schema.stage_rsh_cloudwatch_datapoints table, $pg_host , port: $pg_port , db: $pg_db "
		    fi

		else
		    # update status for request - with 0 data retrived from cloudwatch
		    writelog "there is no data in $am_cloudwatch_requests_data retrieved from cloudwatch"
		    dtm_batch_completed=$(date +"%Y-%m-%d %H:%M:%S")
		    f_update_request_status "${am_cloudwatch_requests_ids_batch}" "$dtm_batch_completed" "true" "false" "false"
		fi
		## if at least one metric and date range completed    

		    
		    ## update status for unsuccessful  
		    ### finished_at is_done is_aborted is_sucesfull
		    
		    if [ "$( wc -l ${am_cloudwatch_requests_data_err} | cut -d\  -f1)" -gt 0 ] 
		    then
			writelog "update status for requests completed with errors in aws cli  "
			f_update_request_status "${am_cloudwatch_requests_data_err}" "$dtm_load_to_stage_completed" "true" "false" "false"
		    fi

		
	    else
		log_msg="There is no active resource metrics links for instance $rs_instance_name - please review active instances list or metrics resources mapping" 
		writelog "$log_msg"
		mail_body="$log_msg"
		mail_subject="$mail_msg_header"
		
		f_sendemail
	    fi
	    
	done < ${rs_active_clusters_list}
	
	writelog "Final check and load if found for stage data not loaded to stats yet"
	f_load_from_stage_to_stat
	
	writelog "Final run aggregation functions"
	f_agg_final_queries

	writelog " $mail_msg_header completed "

else
	writelog "There is no active instances in table ${v_histdb_DB_stat_schema}.dic_instance on host: $pg_host , port: $pg_port , db: $pg_db " 
fi





