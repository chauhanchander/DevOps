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
        email_list="$admin_email_list"

	f_sendemail "$log_dir/$logfile"
	exit 2
}




function get_data_canary_report {

	local l_host="$1"
	local l_port="$2"
	local l_user="$3"
	local l_user_pass="$4"
	local l_db_name="$5"
	local l_resource_name="$6"
	local l_script="$7"
	local l_report_output="$8"


	export PGPASSWORD="$l_user_pass"

	${psqlbinf}  -h $l_host -p $l_port -U $l_user -d $l_db_name -w -f $l_script -v ON_ERROR_STOP=1 -v rname="'$l_resource_name'" >  $l_report_output 2>> $log_dir/$logfile
	chk_rc=$?

	if [ "$chk_rc" -ne 0 ]
	then	
		 f_abort_send_message "error while run script $l_script ON host: $l_host , port: $l_port , user: $l_user , DB_name :  $l_db_name ,resource_name : $l_resource_name "
	fi	
}


###################################
## input prameters
###################################


report_user_name="$1"
report_user_password="$2"


##################################
## path and variables
##################################

tmpfilesdir="/tmp"

#psqlbinf="/app-am/edm/postgres/bin/psql "
psqlbinf="psql "

log_dir="../../logs"
logfile="rs_canary_daily_report.log"

pg_host="pgedmomrp.cicnuemrayu5.us-east-1.rds.amazonaws.com"
pg_port="5458"
pg_db_name="pgperfmon1"

#admin_email_list="EDMStrategicDBServices@cablevision.com"

report_email_list="yfedorch@cablevision.com"
admin_email_list="yfedorch@cablevision.com"

mail_msg_header="MSTR Canary Monitor Daily report "

#script_dir="/appbisam/DBA/scripts"
script_dir="."
canary_report_sql="pg_canary_daily_report.sql"

out_rsamp1="rsamp1_canary_sessions_daily_report.txt"
out_rsamp1d="rsamp1d_canary_sessions_daily_report.txt"


writelog "Start select data for Daily Canary Monitor report for rsamp1"

# rsamp1 cluster report
get_data_canary_report $pg_host $pg_port $report_user_name $report_user_password $pg_db_name rsamp1 $script_dir/$canary_report_sql $log_dir/$out_rsamp1

writelog "Start select data for Daily Canary Monitor report for rsamp1d"
# rsamp1d cluster report
get_data_canary_report $pg_host $pg_port $report_user_name $report_user_password $pg_db_name rsamp1d $script_dir/$canary_report_sql $log_dir/$out_rsamp1d


writelog "Sending report ..."

mail_subject="${mail_msg_header} "
mail_body="${mail_msg_header} - Please Canary monitor sessions details in attached files"
email_list="$report_email_list"

echo "$mail_body" | mailx -a "$log_dir/$out_rsamp1" -a "$log_dir/$out_rsamp1d" -s "$mail_subject" "$email_list"

writelog "report has been sent to $email_list"



