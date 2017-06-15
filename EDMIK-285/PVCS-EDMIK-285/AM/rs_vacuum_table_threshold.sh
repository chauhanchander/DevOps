#!/bin/bash

#!/bin/bash

################################################################################
# Script to run vacuum  in Redshift DB
################################################################################
# Check Status
#
#
# Changelog:
# ----------
# 2015-11-03    yfedorchuk 


function rotate_log {

f_name=$1
f_age=$2

dt_fmt=`date +%Y%m%d`
dt_fmt=${dt_fmt}.$$

fln=$(find ${log_dir} -name ${f_name}* -mtime +$f_age -type f | wc -l |cut -d\  -f1)

if [ ${fln} -gt 0 ]
then

find ${log_dir} -name ${f_name}* -mtime +$f_age -type f -print0 | tar -czf ${log_dir}/bckp_${f_name}_${dt_fmt}.tar.gz --null -T -
rc=$?

if [ ${rc} -le 1 ]
then
        find ${log_dir} -name ${f_name}* -mtime +$f_age -type f -exec rm -f {} \;
fi


fi

}

function writelog {
  echo "[`date '+%Y-%m-%d %T'`]: "$1 >> $log_dir/$logfile
  echo $1
}

function fsendemail {

   # This function is to send the email for the input mail_body,mail_subject and email_list
     echo -e "$mail_body" | mailx -s "$mail_subject" "$email_list"
 }
# Main


if [ "$#" -lt 6 ]; then

echo "======================================================================================"
echo "Usage $0 rs_host rs_port rs_db rs_user rs_password rs_schema rs_table rs_vaccum_type rs_threshold_prc"
echo "======================================================================================"
exit 1
fi

log_dir="../logs"
script_dir="."
tmp_dir="/tmp"
log_msg_header="Redshift vacuum table with parameter sscript "

rs_host=$1
rs_port=$2
rs_db=$3
rs_user=$4
rs_password=$5
rs_schema=$6
rs_table=$7
rs_vaccum_type=$8
rs_threshold_prc=$9

email_list="yfedorch@cablevision.com"

export PGPASSWORD=${rs_password}

rs_host_id=$(echo $rs_host | cut -d\. -f1 |tr -d " ")

clusterID=$(echo $rs_host | cut -d\. -f1 |tr -d " ")

logfile="${clusterID}_table_${rs_schema}.${rs_table}_vacuum.log"

# small fixup for log dir path if it is relative
if [ ${log_dir::1} != "/" ]; then
  log_dir="`dirname $0`/$log_dir"
fi 

# small fixup for dir paths if they are relative
if [ ${script_dir::1} != "/" ]; then
  script_dir="`dirname $0`/$script_dir"
fi

# Verify if the log directory exists
if ! [ -d $log_dir ]; then
  err_msg="Cannot find log directory ${log_dir}. Script $0 cannot proceed. Aborting. Input parameters:database: ${rs_db} host: ${rs_host} port: ${rs_port}"
  mail_body="${err_msg}"
  mail_subject="${log_msg_header} Missing log directory , while running $0  for  ${rs_db} host: ${rs_host} port: ${rs_port} "
  fsendemail
  exit 10
fi


if [ "$rs_threshold_prc" -gt 0 ]
then
	cmd_line="VACUUM ${rs_vaccum_type} ${rs_schema}.${rs_table} TO ${rs_threshold_prc} percent;"
else
	cmd_line="VACUUM ${rs_vaccum_type} ${rs_schema}.${rs_table} ;"
fi


writelog "start  $cmd_line"

rs_cmd=`/app-am/edm/postgres/bin/psql -v ON_ERROR_STOP=1 -h $rs_host -p $rs_port -d $rs_db -U $rs_user -w -c "${cmd_line}" >> ${log_dir}/${logfile} 2>&1`

rs_cmd_status=$?

if [ ${rs_cmd_status} -ne 0 ]
then
        error_msg="Error while executing the command ${cmd_line} in Redshift database ${rs_db} host: ${rs_host} port: ${rs_port}"
        writelog "${error_msg}"
	mail_body=`cat ${log_dir}/${logfile}`
	mail_subject="${rs_host} ${log_msg_header} aborted ,  Redshift database ${rs_db}"
	fsendemail
	exit 1
else
        log_msg="completed command: ${cmd_line}"
        writelog "${log_msg}"
	mail_body=`cat ${log_dir}/${logfile}`
        mail_subject="${rs_host} ${log_msg_header} ${rs_schema}.${rs_table} completed for Redshift database ${rs_db}"
fi

##mv -f $log_dir/$logfile $log_dir/${logfile}.${date_fmt}.$$
##rotate_log ${logfile} 7





