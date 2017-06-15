#!/bin/ksh
# Purpose: This script is to launch Netezza commands from  Appworx
# Created: yfedorch - 03/02/2015
# Modified: yfedorch - 06/16/2015 
rmtusr=$1
rmthost=$2
hostname=`hostname`
ssh -l ${rmtusr} -n ${rmthost} " /export/home/nz/DBA/maint/Appworx/alert_list_db_size.sh \"WORKDB:WORKMSDB\" 3145728 "EDMProdMgmt@cablevision.com,EDMStrategicDBServices@cablevision.com,yfedorch@cablevision.com,ewang@cablevision.com,august.costanza@cablevision.com" >> /export/home/nz/DBA/maint/Appworx/log/${hostname}_alert_list_db_size_ssh.log 2>&1"
ssh -l ${rmtusr} -n ${rmthost} "tail -1 /export/home/nz/DBA/maint/Appworx/log/${hostname}_alert_list_db_size_ssh.log"
###
### End of script
###