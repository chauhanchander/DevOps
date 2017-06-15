#!/bin/ksh
# Purpose: This script is to launch Netezza commands from  Appworx
# Created: yfedorch - 03/11/2015
rmtusr=$1
rmthost=$2
dbname=$3
tblname=$4
genstat_type=$5


hostname=`hostname`
ssh -l ${rmtusr} -n ${rmthost} " /export/home/nz/DBA/maint/Appworx/run_genstat_db_table_type.sh ${dbname} ${tblname} ${genstat_type} >> /export/home/nz/DBA/maint/Appworx/log/${hostname}_run_genstat_db_table_type.log 2>&1"
ssh -l ${rmtusr} -n ${rmthost} "tail -1 /export/home/nz/DBA/maint/Appworx/log/${hostname}_run_genstat_db_table_type.log"
###
### End of script
###