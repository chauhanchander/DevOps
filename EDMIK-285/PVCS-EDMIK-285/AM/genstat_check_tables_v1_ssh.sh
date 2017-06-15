#!/bin/ksh
# Purpose: This script is to launch Netezza commands from  Appworx
# Created: yfedorch - 03/11/2015

rmtusr=$1
rmthost=$2

hostname=`hostname`
ssh -l ${rmtusr} -n ${rmthost} " /export/home/nz/DBA/maint/Appworx/genstat_check_tables_v1.sh /export/home/nz/DBA/maint/Appworx/genstats_randy_input_tables.in >> /export/home/nz/DBA/maint/Appworx/log/${hostname}_genstat_randy_input_tables.log 2>&1"
ssh -l ${rmtusr} -n ${rmthost} "tail -1 /export/home/nz/DBA/maint/Appworx/log/${hostname}_genstat_randy_input_tables.log"
###
### End of script
###