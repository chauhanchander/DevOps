#!/bin/ksh
# Purpose: This script is to launch Netezza commands from  Appworx
# Created: yfedorch - 03/11/2015

rmtusr=$1
rmthost=$2

hostname=`hostname`
ssh -l ${rmtusr} -n ${rmthost} " /export/home/nz/DBA/maint/Appworx/check_db_tbl_groom_all.sh /export/home/nz/DBA/maint/Appworx/prm_check_groom_all_records.in yfedorch@cablevision.com >> /export/home/nz/DBA/maint/Appworx/log/${hostname}_check_db_tbl_groom_all.log 2>&1"
ssh -l ${rmtusr} -n ${rmthost} "tail -1 /export/home/nz/DBA/maint/Appworx/log/${hostname}_check_db_tbl_groom_all.log"
###
### End of script
###