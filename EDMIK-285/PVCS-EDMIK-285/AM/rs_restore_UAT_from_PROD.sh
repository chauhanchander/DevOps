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

	if [ -n "$l_file_attach" ]
	then
		echo "$mail_body" | mailx -a "$l_file_attach" -s "$mail_subject" "$email_list"
	else
         	echo "$mail_body" | mailx -s "$mail_subject" "$email_list"
	fi 
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
function f_get_aws_key_from_config {

##################################
# get aws keys from  ~/.aws/credentials
##################################

	local l_aws_profile=$1

	cfg_aws_access_key_id=$(grep "\[${l_aws_profile}\]" -A2 ~/.aws/credentials |grep "aws_access_key_id" |awk -F"=" ' { print $2 } ' |tr -d " ")
	cfg_aws_secret_access_key=$(grep "\[${l_aws_profile}\]" -A2 ~/.aws/credentials |grep "aws_secret_access_key" |awk -F"=" ' { print $2 } ' |tr -d " ")

	if [ -z "$cfg_aws_access_key_id" ]
	then
		 f_abort_send_message "error while retrieving aws cli aws_access_key_id for profile $l_aws_profile"
	fi 

	if [ -z "$cfg_aws_secret_access_key" ]
	then
		 f_abort_send_message "error while retrieving aws cli aws_access_key_id for profile $l_aws_profile"
	fi 

}

##############################################
function f_chk_cluster_exists {

##################################
# check if cluster exists
##################################

	local l_cluster_ID=$1
	local l_abort_script=$2
	local chk_cluster_ID=""
	local chk_rc=0

	chk_cluster_ID=$(${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].{clusterID:ClusterIdentifier}' --output text )
	chk_rc=$?
	
	#echo $chk_rc
	#echo $chk_cluster_ID

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error check existence cluster $l_cluster_ID - aws cli error during check"
	fi
	
	if [ -n "$chk_cluster_ID" ]	
	then 
		# cluster exists 
		chk_cluster_exists=0
		return 0
	else
		chk_cluster_exists=1
		if [ "$l_abort_script" == 'Y' ]
		then
			f_abort_send_message "check existence cluster $l_cluster_ID - failed -  cluster doesn't exists , abort the script"
		fi
	fi
}


##############################################
function f_get_cluster_settings {

#####################################
# get cluster setting : host ,port,av_zone .... 
#####################################

	local l_cluster_ID=$1
	local str_size=0

################
# get host_name 
################
	tgt_cluster_host=$( ${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].{host_name:Endpoint.Address}' --output text ) 
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while get host_name  for cluster $l_cluster_ID - aws cli error during operation "
	fi	

	# host_name  
	if [ -n "$tgt_cluster_host" ]
	then
		writelog "get $l_cluster_ID cluster host_name:  $tgt_cluster_host "
	else 
		f_abort_send_message  "error while get Endpoint.Address for cluster $l_cluster_ID  - get blank string from aws - check Endpoint.Address for cluster or script code "
	fi 

################
# get port number 
################
	tgt_cluster_port=$( ${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].{Port:Endpoint.Port}' --output text ) 
	chk_rc=$?
	
	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while get port number for cluster $l_cluster_ID - aws cli error during operation "
	fi
	
	#check port number  	
	if [ -n tgt_cluster_port ]
	then 
		str_size=${#tgt_cluster_port}
		if [ "$str_size" -ne 4 ]
		then
			f_abort_send_message "error while get port number for cluster $l_cluster_ID - port number length doesn't equal 4  "
		else
			writelog "get  $l_cluster_ID cluster  port number $tgt_cluster_port "
		fi 
	else
		 f_abort_send_message  "error while get port number for cluster $l_cluster_ID  - get blank string from aws - check script code  "
	fi

###################
# get availability-zone 
###################
	tgt_av_zone=$( ${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].{AVZone:AvailabilityZone}' --output text ) 
	chk_rc=$?
	
	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while get availability-zone for cluster $l_cluster_ID - aws cli error during operation "
	fi	


	if [ -n "$tgt_av_zone" ]
	then
		writelog "get  $l_cluster_ID cluster  availability-zone:  $tgt_av_zone "
	else 
		f_abort_send_message  "error while get availability-zone for cluster $l_cluster_ID  - get blank string from aws - check avialability zone for cluster or script code "
	fi 

############################
# get cluster-subnet-group-name
############################

	tgt_cluster_subnet_grp_nm=$( ${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].{ClusterSubnetGroupName:ClusterSubnetGroupName}' --output text )
	chk_rc=$?
	
	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while get cluster-subnet-group-name for cluster $l_cluster_ID - aws cli error during operation "
	fi	


	if [ -n "$tgt_cluster_subnet_grp_nm" ]
	then
		writelog "get UAT $l_cluster_ID cluster-subnet-group-name:  $tgt_cluster_subnet_grp_nm "
	else 
		f_abort_send_message  "error while get cluster-subnet-group-name for cluster $l_cluster_ID  - get blank string from aws - check cluster-subnet-group-name for cluster or script code "
	fi 

##############################
# get cluster-parameter-group-name
##############################

	tgt_cluster_prm_grp_nm=$( ${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[ClusterParameterGroups[*].ParameterGroupName]' --output text )
	chk_rc=$?
	
	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while get cluster-parameter-group-name for cluster $l_cluster_ID - aws cli error during operation "
	fi	


	if [ -n "$tgt_cluster_prm_grp_nm" ]
	then
		writelog "get  $l_cluster_ID cluster-parameter-group-name:  $tgt_cluster_prm_grp_nm "
	else 
		f_abort_send_message  "error while get cluster-parameter-group-name for cluster $l_cluster_ID  - get blank string from aws - check cluster-parameter-group-name for cluster or script code "
	fi 

##############################
# get vpc-security-group-ids
##############################
	
	tgt_vpc_security_grp_ids=$( ${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[VpcSecurityGroups[*].VpcSecurityGroupId]' --output text )
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while get vpc-security-group-ids for cluster $l_cluster_ID - aws cli error during operation "
	fi	


	if [ -n "$tgt_vpc_security_grp_ids" ]
	then
		writelog "get  $l_cluster_ID vpc-security-group-ids:  $tgt_vpc_security_grp_ids"
	else 
		f_abort_send_message  "error while get vpc-security-group-ids for cluster $l_cluster_ID  - get blank string from aws - check vpc-security-group-idsfor cluster or script code "
	fi 	

##############################
# get node-type
##############################

	tgt_node_type=$(${awsbinf} redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[NodeType]' --output text)
	chk_rc=$?

	if [ -n "$tgt_node_type" ]
	then
		writelog "get  $l_cluster_ID node-type:  $tgt_node_type"
	else 
		f_abort_send_message  "error while get node-type for cluster $l_cluster_ID  - get blank string from aws - check node-type  or script code "
	fi 

##############################
# get number of nodes
##############################

	tgt_number_of_nodes=$(${awsbinf} redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[NumberOfNodes]' --output text)
	chk_rc=$?

	if [ -n "$tgt_number_of_nodes" ]
	then
		writelog "get  $l_cluster_ID NumberOfNodes:  $tgt_number_of_nodes"
	else 
		f_abort_send_message  "error while get number_of_nodes for cluster $l_cluster_ID  - get blank string from aws - check NumberOfNodes  or script code "f
	fi 

}





##############################################

function f_rename_DB {

	local l_cluster_host=$1
	local l_cluster_port=$2
	local l_cluster_user=$3
	local l_scr_db_name=$4
	local l_tgt_db_name=$5

	${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d dev -w -t -c "ALTER database $l_scr_db_name RENAME TO $l_tgt_db_name ; "  >> $log_dir/$logfile 2>> $log_dir/$logfile
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while run \"ALTER database $l_scr_db_name RENAME TO $l_tgt_db_name  \"; on  cluster $l_cluster_host psql error  "
	fi	


}

function f_run_sql_scripts {

	local l_cluster_host=$1
	local l_cluster_port=$2
	local l_cluster_user=$3
	local l_db_name=$4
	local l_sql_script_name=$5

	${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d $l_db_name -w -t -af $l_sql_script_name >> $log_dir/$logfile 2>> $log_dir/$logfile
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while run script $l_sql_script_name; on  cluster $l_cluster_host  "
	fi	

}


##############################################
function f_get_ddl_for_tables_list {

###############################################
# get DDL from DB for tables listed in input file 
# view cvadmin.v_generate_tbl_ddl should exists in DB 
###############################################

	local l_ddl_tables_list=$1
	local l_cluster_host=$2
	local l_cluster_port=$3
	local l_cluster_user=$4
	local l_db_name=$5

while read tbl_ln
do

	tbl_schema=$(echo $tbl_ln | awk -F"." ' { print $1 }')
	tbl_nm=$(echo $tbl_ln | awk -F"." ' { print $2 }')

	ddl_out_fl_nm="${tgt_clusterID}_tbl_DDL_${target_db_name}_${tbl_schema}_${tbl_nm}.ddl"

	writelog "start Extract DDL for table $tbl_nm; DB: $target_db_name into ${refresh_UAT_dir}/out/${ddl_out_fl_nm} "
	
	${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d $l_db_name -w -t -c " SELECT ddl FROM cvadmin.v_generate_tbl_ddl WHERE schemaname ='${tbl_schema}' AND tablename='${tbl_nm}';  "  > ${refresh_UAT_dir}/out/${ddl_out_fl_nm} 2>> $log_dir/$logfile
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while extract DDL for  schemaname ='${tbl_schema}' AND tablename='${tbl_nm} ; DB: $l_db_name ; cluster $l_cluster_host psql error  "
	fi	
	
done < $l_ddl_tables_list

}


##############################################
function f_create_ddl_for_tables_list {

	local l_ddl_tables_list=$1
	local l_cluster_host=$2
	local l_cluster_port=$3
	local l_cluster_user=$4
	local l_db_name=$5

while read tbl_ln
do

	tbl_schema=$(echo $tbl_ln | awk -F"." ' { print $1 }')
	tbl_nm=$(echo $tbl_ln | awk -F"." ' { print $2 }')

	ddl_out_fl_nm="${tgt_clusterID}_tbl_DDL_${target_db_name}_${tbl_schema}_${tbl_nm}.ddl"

	writelog "start run DDL for table $tbl_nm; DB: $target_db_name from ${refresh_UAT_dir}/out/${ddl_out_fl_nm} "
	
	${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d $l_db_name -w -t -af  ${refresh_UAT_dir}/out/${ddl_out_fl_nm} >>$log_dir/$logfile  2>> $log_dir/$logfile
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error run DDL for table $tbl_nm; DB: $target_db_name from ${refresh_UAT_dir}/out/${ddl_out_fl_nm} "
	fi	

done < $l_ddl_tables_list

}


##############################################
function f_export_tables_data {

	local l_exp_tables_list=$1
	local l_cluster_host=$2
	local l_cluster_port=$3
	local l_cluster_user=$4
	local l_db_name=$5

while read tbl_ln
do

	tbl_schema=$(echo $tbl_ln | awk -F"." ' { print $1 }')
	tbl_nm=$(echo $tbl_ln | awk -F"." ' { print $2 }')

	exp_dt_out_fl_nm="${tgt_clusterID}_exp_data_${target_db_name}_${tbl_schema}_${tbl_nm}.out"

	writelog "start export data for table $tbl_nm; DB: $target_db_name into ${refresh_UAT_dir}/out/${exp_dt_out_fl_nm} "
	
	${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d $l_db_name -w -t -c " SELECT * FROM $tbl_ln ;  "  > ${refresh_UAT_dir}/out/${exp_dt_out_fl_nm} 2>> $log_dir/$logfile
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while export data into ${refresh_UAT_dir}/out/${exp_dt_out_fl_nm}  for table  $tbl_ln ; DB: $target_db_name ; cluster $l_cluster_host psql error  "
	fi
done < $l_exp_tables_list

}

##############################################
function f_export_tables_data_to_S3 {

####################################
# export tables to S3 bucket 
####################################

	local l_exp_tables_list=${1}
	local l_cluster_host=${2}
	local l_cluster_port=${3}
	local l_cluster_user=${4}
	local l_db_name=${5}
	local l_exp_s3_bucket=${6}
	local l_aws_access_key_id=${7}
	local l_aws_secret_access_key=${8}
	local l_allow_overwrite=${9}

	local str_allow_overwrite=""

while read tbl_ln
do

	if [ "$l_allow_overwrite" == "Y" ]
	then
		str_allow_overwrite="ALLOWOVERWRITE"
	fi

	tbl_schema=$(echo $tbl_ln | awk -F"." ' { print $1 }' | tr '[:upper:]' '[:lower:]')
	tbl_nm=$(echo $tbl_ln | awk -F"." ' { print $2 }' | tr '[:upper:]' '[:lower:]')


	writelog "start export data for table $tbl_nm; DB: $target_db_name to S3 bucket ${l_exp_s3_bucket} "
	
	${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d $l_db_name -w -t -c "unload ('SELECT * FROM $tbl_ln ') to '${l_exp_s3_bucket}/$tbl_schema-$tbl_nm/$tbl_schema-$tbl_nm.gz' credentials 'aws_access_key_id=${l_aws_access_key_id};aws_secret_access_key=${l_aws_secret_access_key}' gzip escape  $str_allow_overwrite"  >> $log_dir/$logfile 2>>$log_dir/$logfile
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while export data to S3 bucket ${l_exp_s3_bucket}/$tbl_schema-$tbl_nm/  for table $tbl_ln ; DB: $l_db_name ; cluster $l_cluster_host psql error  "
	fi
done < $l_exp_tables_list

}

#############################################

function f_load_data_from_S3 {

####################################
# load tables from S3 bucket 
####################################

	local l_load_tables_list=${1}
	local l_cluster_host=${2}
	local l_cluster_port=${3}
	local l_cluster_user=${4}
	local l_db_name=${5}
	local l_load_s3_bucket=${6}
	local l_aws_access_key_id=${7}
	local l_aws_secret_access_key=${8}
	local l_truncate_table=${9}

while read tbl_ln
do

	tbl_schema=$(echo $tbl_ln | awk -F"." ' { print $1 }' | tr '[:upper:]' '[:lower:]')
	tbl_nm=$(echo $tbl_ln | awk -F"." ' { print $2 }' | tr '[:upper:]' '[:lower:]')

	if [ "$l_truncate_table" == "Y" ]
	then
		writelog "Start : truncate table $tbl_nm; DB: $target_db_name before loading data from S3"

		${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d $l_db_name -w -t -a -c "TRUNCATE table $tbl_ln;" >> $log_dir/$logfile 2>> $log_dir/$logfile
		chk_rc=$?
		if [ "$chk_rc" -ne 0 ]
		then	
			 f_abort_send_message "Error while truncate table $tbl_ln; DB: $target_db_name before loading data from S3"
		fi		

		writelog "Done : truncate table $tbl_ln; DB: $target_db_name before loading data from S3"
	fi

	writelog "start load data for table $tbl_ln; DB: $target_db_name from S3 bucket ${l_load_s3_bucket}/$tbl_schema-$tbl_nm/ "
	
	${psqlbinf}  -h $l_cluster_host -p $l_cluster_port -U $l_cluster_user -d $l_db_name -w -a -c "COPY $tbl_ln FROM '${l_load_s3_bucket}/$tbl_schema-$tbl_nm/' credentials 'aws_access_key_id=${l_aws_access_key_id};aws_secret_access_key=${l_aws_secret_access_key}' gzip escape acceptinvchars acceptanydate delimiter '|' maxerror 1000 truncatecolumns trimblanks"  >> $log_dir/$logfile 2>>$log_dir/$logfile

	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while load data for table $tbl_nm; DB: $target_db_name from S3 bucket ${l_load_s3_bucket}/$tbl_schema-$tbl_nm/, check log file and STL_LOAD_ERRORS on l_cluster_host"
	fi
done < $l_load_tables_list



}


##############################################
function f_check_snapshot_status {

################################
# check snapshot status 
################################

	local l_snapshot_ID=$1

	manual_snapshot_status=$(${awsbinf}  redshift describe-cluster-snapshots --snapshot-identifier $l_snapshot_ID --query 'Snapshots[*].[Status]' --output text)
	manual_snapshot_progressMB=$(${awsbinf}  redshift describe-cluster-snapshots --snapshot-identifier $l_snapshot_ID --query 'Snapshots[*].[BackupProgressInMegaBytes]' --output text)
	manual_snapshot_est_sec=$(${awsbinf}  redshift describe-cluster-snapshots --snapshot-identifier $l_snapshot_ID --query 'Snapshots[*].[EstimatedSecondsToCompletion]' --output text)

	writelog "Check status for manual snapshot $l_snapshot_ID ; Status : $manual_snapshot_status ; BackupProgressInMegaBytes : $manual_snapshot_progressMB ; EstimatedSecondsToCompletion : $manual_snapshot_est_sec"

	if [ "$manual_snapshot_status" == "failed" ]
	then
		${awsbinf}  redshift describe-cluster-snapshots --snapshot-identifier $l_snapshot_ID >> $log_dir/$logfile 2>>$log_dir/$logfile
		wait
	
		 f_abort_send_message "error while create snapshot $l_snapshot_ID : Status : $manual_snapshot_status"
	fi
}

##############################################
function f_create_manual_snapshot  {

#######################################
# create manual snapshot 
# function wait until snapshot become avilable
#######################################

	local l_cluster_ID=$1
	local l_snapshot_ID=$2

	${awsbinf}  redshift create-cluster-snapshot --snapshot-identifier $l_snapshot_ID --cluster-identifier $l_cluster_ID >> $log_dir/$logfile 2>>$log_dir/$logfile
	wait
	chk_rc=$?
	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while start create snapshot $l_snapshot_ID for cluster $l_cluster_ID "
	fi
	
	manual_snapshot_status=""
	
	until [ "$manual_snapshot_status" == "available" ]
	do 	
		sleep 60
		f_check_snapshot_status "$l_snapshot_ID"		
	done
	
	writelog "Snapshot for cluster $l_cluster_ID with name $l_snapshot_ID has been created and in status $manual_snapshot_status"
}

##############################################
function f_delete_cluster {

############################
# delete cluster 
############################
	local l_cluster_ID=$1
	local l_final_snapshot=$2
	
	local l_final_snapshot_name="$l_cluster_ID-final-${logdate}"
	local chk_cluster_status=""

	writelog " check cluster $l_cluster_ID status before delete "
	chk_cluster_status=$(${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[ClusterStatus]' --output text )
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while checking status for cluster $l_cluster_ID before delete"
	fi

	writelog " cluster $l_cluster_ID in status : $chk_cluster_status "

	if [ "$chk_cluster_status" == "available" ]
	then

		if [ "$l_final_snapshot" == "Y" ]
		then
			writelog "Start delete cluster $l_cluster_ID with final snapshot $l_final_snapshot_name"
	
			${awsbinf} redshift delete-cluster --cluster ${l_cluster_ID} --final-cluster-snapshot-identifier $l_final_snapshot_name  >> $log_dir/$logfile 2>>$log_dir/$logfile
			chk_rc=$?
			
			if [ "$chk_rc" -ne 0 ]
			then	
				 "error while start delete cluster $l_cluster_ID  "
			fi			
			
			manual_snapshot_status=""
	
			until [ "$manual_snapshot_status" == "available" ]
			do 
				sleep 60
				f_check_snapshot_status "$l_final_snapshot_name"				
			done
	
			writelog "Snapshot for cluster $l_cluster_ID with name $l_final_snapshot_name has been created and in status $manual_snapshot_status"

		else
			writelog "Start delete cluster $l_cluster_ID without final snapshot"

			${awsbinf} redshift delete-cluster --cluster ${l_cluster_ID} --skip-final-cluster-snapshot >> $log_dir/$logfile 2>>$log_dir/$logfile		
		fi
	
		chk_cluster_exists=0
	
		until [ "$chk_cluster_exists" -eq 1 ]
		do
			sleep 60
			f_chk_cluster_exists "$l_cluster_ID" N

			chk_cluster_status=$(${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[ClusterStatus]' --output text )
			writelog "Cluster $l_cluster_ID status : $chk_cluster_status "			
		done
	
		writelog "Cluster $l_cluster_ID has been deleted"
		chk_cluster_deleted=0
	else
		f_abort_send_message "cluster $l_cluster_ID not in Status :avilable , current Status $chk_cluster_status"
	fi 
}

#############################################
function f_check_cluster_restore_status {

	local l_cluster_ID=$1
	local ch_rc=0
	chk_restore_status=$(${awsbinf} redshift describe-clusters --cluster-identifier ${l_cluster_ID} --query 'Clusters[*].[RestoreStatus.Status]' --output=text ) 
	ch_rc=$?

	if [ "$ch_rc" -ne 0 ]
	then
		writelog "error while retrive RestoreStatus for Cluster $l_cluster_ID"
	fi 
	${awsbinf} redshift describe-clusters --cluster-identifier ${l_cluster_ID} --query 'Clusters[*].[RestoreStatus]' --output=json >> $log_dir/$logfile 2>>$log_dir/$logfile
}

##############################################
function f_alert_cluster_status {

	local l_cluster_ID=$1
	
	local if_status_error=0
	local list_alert_status="hardware-failure incompatible-hsm incompatible-network incompatible-parameters incompatible-restore storage-full"
	local st=""
	#get cluster status
	${awsbinf} redshift describe-clusters --cluster-identifier ${l_cluster_ID} --query 'Clusters[*].{ClusterStatus:ClusterStatus}' --output=text  > ${tmpfilesdir}/temp_rest_${l_cluster_ID}_f_check_cstatus.tmp
	wait
	
	for st in `echo $list_alert_status`
	do
	    if_status_error=$(grep "$st" ${tmpfilesdir}/temp_rest_${l_cluster_ID}_f_check_cstatus.tmp |wc -l | cut -d\  -f1)
	    if [ "$if_status_error" -gt 0 ]
	    then
		f_abort_send_message "Error restore cluster $l_cluster_ID from snapshot $l_snapshot ; Cluster  Status :  \" $st \"    "
           fi
	done
}

##################################################
function  f_restore_cluster_from_snapshot {

	local l_cluster_ID=$1
	local l_cluster_port=$2
	local l_AV_zone=$3
	local l_SUBNET_gr=$4
	local l_PRM_gr=$5
	local l_VPC_sec_gr=$6
	local l_public_acc=$7
	local l_snapshot=$8

	local ch_rc=0

	writelog "Restore from snapshot parameters : ClusterID : $l_cluster_ID , port : $l_cluster_port ;availability-zone :  $l_AV_zone ;  cluster-subnet-group-name  : $l_SUBNET_gr ; cluster-parameter-group-name : $l_PRM_gr ; vpc-security-group-ids : $l_VPC_sec_gr ; publicly-accessible : $l_public_acc ; snapshot-identifier : $l_snapshot"

	if [ "$l_public_acc" == "Y" ]
	then
		${awsbinf} redshift restore-from-cluster-snapshot --cluster-identifier ${l_cluster_ID} --port ${l_cluster_port} --snapshot-identifier ${l_snapshot} --availability-zone ${l_AV_zone} --cluster-subnet-group-name ${l_SUBNET_gr} --cluster-parameter-group-name ${l_PRM_gr} --vpc-security-group-ids ${l_VPC_sec_gr} >> $log_dir/$logfile 2>>$log_dir/$logfile
		ch_rc=$?
	else
		${awsbinf} redshift restore-from-cluster-snapshot --cluster-identifier ${l_cluster_ID} --port ${l_cluster_port} --snapshot-identifier ${l_snapshot} --availability-zone ${l_AV_zone} --cluster-subnet-group-name ${l_SUBNET_gr} --cluster-parameter-group-name ${l_PRM_gr} --vpc-security-group-ids ${l_VPC_sec_gr} --no-publicly-accessible >> $log_dir/$logfile 2>>$log_dir/$logfile
		ch_rc=$?
	fi

	if [ "$ch_rc" -eq 0 ]
	then
		
		until [ "$chk_restore_status" == "completed" ]
		do
			sleep 60

# check restore status
			f_check_cluster_restore_status "$l_cluster_ID"
	
			if [ "$chk_restore_status" == "failed"  ]
			then
				
				f_abort_send_message "Error restore cluster $l_cluster_ID from snapshot $l_snapshot ; Restore Status : $chk_restore_status   "
			fi

# check cluster status
			chk_cluster_status=$(${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[ClusterStatus]' --output text )
			writelog "Cluster $l_cluster_ID status : $chk_cluster_status "
			
			f_alert_cluster_status "$l_cluster_ID"

		done 
		
	else
		f_abort_send_message "error while start restore cluster $l_cluster_ID from snapshot $l_snapshot"
	fi 
}

############################################
function f_check_resize_status {

	local l_cluster_ID=$1

	chk_resize_status=$(${awsbinf} redshift describe-resize --cluster-identifier ${l_cluster_ID} --query 'Status' --output text)

	chk_rc=$?
	if [ "$chk_rc" -ne 0 ]
	then	
		writelog "error while check resize status for cluster $l_cluster_ID "
	fi	
}


############################################
function f_resize_cluster {

	local l_cluster_ID=$1
	local l_node_type=$2
	local l_number_nodes=$3


	${awsbinf} redshift modify-cluster --cluster-identifier ${l_cluster_ID}  --cluster-type multi-node --node-type $l_node_type --number-of-nodes ${l_number_nodes}  >> $log_dir/$logfile 2>> $log_dir/$logfile 
	chk_rc=$?
			
	if [ "$chk_rc" -ne 0 ]
	then	
		f_abort_send_message "error while start resize cluster $l_cluster_ID "
	fi
	
	until [ "$chk_resize_status" == "SUCCEEDED" ]
	do
		sleep 60

	 	f_check_resize_status $l_cluster_ID
		writelog " Resize status $chk_resize_status"

		${awsbinf} redshift describe-resize --cluster-identifier ${l_cluster_ID}  --output json >> $log_dir/$logfile 2>> $log_dir/$logfile

# check cluster status
		chk_cluster_status=$(${awsbinf}  redshift describe-clusters --query 'Clusters[?ClusterIdentifier==`'$l_cluster_ID'`].[ClusterStatus]' --output text )
		writelog "Cluster $l_cluster_ID status : $chk_cluster_status "

		if [ "$chk_resize_status" == "FAILED" ]
		then
			f_abort_send_message "error while resize  cluster $l_cluster_ID ; resize status : $chk_resize_status ; cluster status : $chk_cluster_status"
		fi 

		f_alert_cluster_status $l_cluster_ID

	done
	
}

###################################
## input prameters
###################################

aws_profile=${1}
rs_user=${2}
rs_password=${3}
src_cluster_ID=${4}
tgt_clusterID=${5}
source_db_name=${6}
target_db_name=${7}

logdate=$(date +"%m%d%Y-%H%M")



##################################
## path and variables
##################################

tmpfilesdir="/tmp"
awsbinf="aws --profile=$aws_profile "
psqlbinf="psql "
log_dir="../logs"
logfile="rs_refresh_redshift_UAT_from_PROD_$logdate.log"

#email_list="EDMStrategicDBServices@cablevision.com,yfedorchuk@cablevision.com,ewang@cablevision.com,pageelliewang@cablevision.com"

email_list="yfedorch@cablevision.com"
mail_msg_header="Redshift maintenance Refresh UAT from PROD"

src_shapshot_Name="${src_cluster_ID}-${logdate}"
tgt_shapshot_Name="${tgt_clusterID}-${logdate}"

refresh_UAT_dir="refresh_UAT_set"
exp_s3_bucket="s3://test-rs-refresh/ts1"

get_ddl_tables_list="${refresh_UAT_dir}/uat_extract_ddl_tables.lst"
exp_data_tables_list="${refresh_UAT_dir}/uat_export_data_tables.lst"

reset_app_ids_sql="${refresh_UAT_dir}/uat_reset_app_ids.sql"
tgt_purge_data_sql="${refresh_UAT_dir}/uat_purge_data.sql"

####################################
# get aws_access_key_id and aws_secret_access_key from profile
####################################
writelog "start get aws_access_key_id and aws_secret_access_key for profile  $aws_profile"

f_get_aws_key_from_config $aws_profile 
writelog "retrieved aws key id $cfg_aws_access_key_id"


###################################
# Check number of input parameters
###################################

writelog "start check input parameters"

if [ "$#" -lt 7 ]; then
  echo "Usage $0 aws_profile rs_user rs_password src_cluster_name target_cluster_name source_db_name target_db_name"
  exit 1
fi

###################################
# check source and target cluster names 
###################################


if [ -z "$src_cluster_ID" ]
then 
	 f_abort_send_message "wrong source cluster ID :   $src_cluster_ID"
fi

##########################################
# 1. check if target clusters  <> rsamp1
##########################################

if [ "$tgt_clusterID" == "rsamp1" ]
then 

 	f_abort_send_message "wrong target cluster ID :   $tgt_clusterID - target cluster should be UAT cluster "

fi

##########################################
# 2. check if source clusters  <> target cluster 
##########################################

if [ "$tgt_clusterID" == "$src_cluster_ID" ]
then 
	 f_abort_send_message "Source cluster name the same as target cluster name ; $src_cluster_ID = $tgt_clusterID  wrong source cluster ID ors_refresh_redshift_UAT_from_PROD.logr target cluster ID"
fi

##########################################
#echo "rs_user : $rs_user "/rs_restore_UAT_from_PROD.sh cvadmin cvadmin rsamp1 rsamt1 cvrsamp cvrsamt
#echo "rs_password : $rs_password" 
#echo "src_cluster_ID : $src_cluster_ID"
#echo "tgt_clusterID : $tgt_clusterID"
#echo "source_db_name : $source_db_name"
#echo "target_db_name: $target_db_name"
#echo "src_shapshot_Name :$src_shapshot_Name "
#echo "tgt_shapshot_Name : $tgt_shapshot_Name "
##########################################

log_inp_prm_str=" Input parameters list: rs_user : $rs_user  ; \
rs_password : xxxxxxxxxxx ; \
src_cluster_ID : $src_cluster_ID  ; \
tgt_clusterID : $tgt_clusterID ; \
source_db_name : $source_db_name  ; \
target_db_name: $target_db_name;"


writelog "$log_inp_prm_str"

export PGPASSWORD="$rs_password"

##########################################
# 4. check if source clusters exists
##########################################

writelog "Start check if  source  clusters exists"
f_chk_cluster_exists $src_cluster_ID Y

if [ "$chk_cluster_exists" -eq 0 ]
then
	writelog "check source cluster $src_cluster_ID - passed "

else 
	f_abort_send_message "check source cluster $src_cluster_ID - failed  variable chk_cluster_exists doesn't eq 0  abort the script "
fi

##########################################
# 5. check if target clusters exists
##########################################

writelog "Start check if  target  clusters exists"
f_chk_cluster_exists $tgt_clusterID Y

if [ "$chk_cluster_exists" -eq 0 ]
then
	writelog "check target cluster $tgt_clusterID - passed "

else 
	f_abort_send_message "check target cluster $src_cluster_ID - failed  variable chk_cluster_exists doesn't eq 0  abort the script "
fi

#####################################
# 6. get settings from existing UAT cluster
#####################################

writelog "pull existing target cluster settings  $tgt_clusterID "
f_get_cluster_settings $tgt_clusterID 	 

##############################################
# 7. Create manual snapshot for target cluster (backup) could be skipped if we are running shutdown target with final snapshot
##############################################

##writelog "Start create manual snapshot for target cluster $tgt_clusterID with name $tgt_shapshot_Name"

##f_create_manual_snapshot "$tgt_clusterID" "$tgt_shapshot_Name"

##########################################
# 7. Create snapshot for source cluster 
##########################################

writelog "Start: create manual snapshot for source cluster $src_clusterID with name $src_shapshot_Name"

f_create_manual_snapshot "$src_cluster_ID" "$src_shapshot_Name"


##########################################
# 8. Extract DDL for tables list
##########################################

writelog "Start: extract  DDL for tables list from existing cluster  $tgt_clusterID ; DB: $target_db_name "

f_get_ddl_for_tables_list $get_ddl_tables_list $tgt_cluster_host $tgt_cluster_port $rs_user $target_db_name

writelog "Done: extract  DDL for tables list from existing cluster  $tgt_clusterID ; DB: $target_db_name "

##########################################
# 9. Export data from existing UAT to S3
##########################################

writelog "Start: Export data from  $tgt_clusterID ; DB: $target_db_name to S3 bucket $exp_s3_bucket"

f_export_tables_data_to_S3 "$exp_data_tables_list" $tgt_cluster_host $tgt_cluster_port $rs_user $target_db_name "$exp_s3_bucket" "$cfg_aws_access_key_id" "$cfg_aws_secret_access_key" Y

writelog "Done: export data from  $tgt_clusterID ; DB: $target_db_name to S3 bucket $exp_s3_bucket"

##########################################
## optional local copy on EC2
##########################################
##writelog "Start: Export data local from cluster  $tgt_clusterID ; DB: $target_db_name "

##f_export_tables_data "$exp_data_tables_list" $tgt_cluster_host $tgt_cluster_port $rs_user $target_db_name

##writelog "Done: Export data local from cluster  $tgt_clusterID ; DB: $target_db_name  "

##########################################
# 10. Shutdown target_clustertgt_purge_data_sql
##########################################

writelog "Start: shutdown target cluster $tgt_clusterID"

chk_cluster_deleted=1
del_cnt=1

until [ "$chk_cluster_deleted" -eq 0 ]
do
	writelog "shutdown target cluster $tgt_clusterID : $del_cnt attempt "
	f_delete_cluster $tgt_clusterID Y

	if [ "$del_cnt" -gt 3 ]
	then
		f_abort_send_message "tried 3 attempts to delete  $tgt_clusterID - failed  please check $log_dir/$logfile "
	fi
	((del_cnt++))
done


################################################
# 11. Restore target cluster from source cluster snapshot
################################################

writelog "Start restore cluster $tgt_clusterID  from snapshot  $src_shapshot_Name "
chk_restore_status=""
f_restore_cluster_from_snapshot "$tgt_clusterID" "$tgt_cluster_port" "$tgt_av_zone" "$tgt_cluster_subnet_grp_nm" "$tgt_cluster_prm_grp_nm" "$tgt_vpc_security_grp_ids" Y "$src_shapshot_Name"
writelog "Completed restore cluster $tgt_clusterID  from snapshot  $src_shapshot_Name"


################################################
# 12. Rename DB name on target cluster
################################################

writelog "Start: rename database $source_db_name to  $target_db_name on  $tgt_clusterID "

f_rename_DB $tgt_cluster_host $tgt_cluster_port $rs_user $source_db_name $target_db_name

writelog "Done: rename database $source_db_name to  $target_db_name on  $tgt_clusterID "



#######################################################
# 13. Run scripts on target cluster to re-set applications IDs pass
#######################################################

writelog "Start: Run script $reset_app_ids_sql on target $tgt_clusterID  to re-set applications   "

f_run_sql_scripts $tgt_cluster_host $tgt_cluster_port $rs_user $target_db_name $reset_app_ids_sql

writelog "Done:  script $reset_app_ids_sql on target $tgt_clusterID  to re-set applications   "


################################################
# 14. Run purge script on target cluster 
################################################

writelog "Start: Run purge script $tgt_purge_data_sql on target $tgt_clusterID  "

f_run_sql_scripts $tgt_cluster_host $tgt_cluster_port $rs_user $target_db_name $tgt_purge_data_sql

writelog "Done:  purge script $tgt_purge_data_sql on target $tgt_clusterID    "


################################################
# 15. Resize target cluster
################################################

chk_cluster_status=""
chk_resize_status=""

writelog " Start: resize cluster $tgt_clusterID to number of nodes $tgt_number_of_nodes"

f_resize_cluster $tgt_clusterID $tgt_node_type $tgt_number_of_nodes


writelog " Done: resize cluster $tgt_clusterID to number of nodes $tgt_number_of_nodes"


####################################
# 16. Restore tables from DDL extracted (exported on step 8 .)
####################################

writelog " Start: Restore tables from DDL extracted (exported on step 8 .)"

f_create_ddl_for_tables_list $get_ddl_tables_list $tgt_cluster_host $tgt_cluster_port $rs_user $target_db_name

writelog " Done: Restore tables from DDL extracted (exported on step 8 .)"


##################################################################################
# 17. load tables from S3 bucket (exported on step 9 .) tables will be truncated if parameter set Y 
##################################################################################

writelog " Start: Load data from S3  (exported on step 9 .)"

f_load_data_from_S3 "$exp_data_tables_list" $tgt_cluster_host $tgt_cluster_port $rs_user $target_db_name "$exp_s3_bucket" "$cfg_aws_access_key_id" "$cfg_aws_secret_access_key" Y

writelog " Done: Load data from S3  "


##################################################################################
writelog "Refresh for cluster $tgt_clusterID from manual snapshot $src_shapshot_Name completed"

mail_subject="${mail_msg_header} Completed"
mail_body="${mail_msg_header}  Refresh for cluster $tgt_clusterID from manual snapshot $src_shapshot_Name completed"
f_sendemail "$log_dir/$logfile"







