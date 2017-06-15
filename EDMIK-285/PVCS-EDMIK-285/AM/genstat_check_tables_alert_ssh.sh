#!/bin/ksh
# Purpose: This script is to launch Netezza commands from  Appworx
# Created: yfedorch - 03/02/2015
# Modified: yfedorch - 06/16/2015 

rmtusr=$1
rmthost=$2
dbname=$3
distr_list=$4
hostname=`hostname`
ssh -l ${rmtusr} -n ${rmthost} " /export/home/nz/DBA/maint/Appworx/genstat_check_tables_alert.sh ${dbname} \"${distr_list}\" >> /export/home/nz/DBA/maint/Appworx/log/${hostname}_genstat_check_tables_alert_ssh.log 2>&1"
ssh -l ${rmtusr} -n ${rmthost} "tail -1 /export/home/nz/DBA/maint/Appworx/log/${hostname}_genstat_check_tables_alert_ssh.log"
###
### End of script
###