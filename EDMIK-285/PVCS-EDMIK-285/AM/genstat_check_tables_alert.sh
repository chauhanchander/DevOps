#!/bin/bash

cd /export/home/nz
. ~/.bashrc_cvadmin

args=$#
if [ $args -ne 2 ]
then
   echo "======================================================================================"
   echo "Usage $0 dbname email@domain.com OR $0 \"dbname1,dbname2,dbname3\" email@domain.com"
   echo "======================================================================================"
   exit 1
fi

db_nm=$1
distr_list=$2

bin_dir="/nz/kit/bin/"
nz_bins="nzsql"
stats_query_fl="/export/home/nz/DBA/maint/Appworx/check_outdated_stat_db.sql"

loghostname=`hostname`
logfiledir="/export/home/nz/DBA/maint/Appworx/log"
echodat=`date`
logdate=`date +"%m-%d-%y_%H%M"`
logfile="${logfiledir}/${loghostname}_chek_stats_and_alert_${logdate}.log"
calc_outdated=0

dbn=$(echo $db_nm |tr "," " ")

for i in $dbn
do

echodat=`date`
echo "start run ${0} on ${loghostname} DB $i at ${echodat}"
echo "------------------------------------------------------------">> ${logfile}
echo "Outdated statistics on database $i at $echodat " >> ${logfile}
echo "------------------------------------------------------------">> ${logfile}

$bin_dir/$nz_bins -d $i -f $stats_query_fl >> ${logfile} 2>&1

echodat=`date`
echo "check db $i finished at  ${echodat}"
done

calc_outdated=`grep "OUTDATED"  ${logfile} | grep -e "FULL" -e "EXPRESS" | wc -l`

if [ $calc_outdated -ne 0 ];then
	cat  $logfile
	cat  $logfile | mailx -s "Outdated satistics on ${loghostname} DB $db_nm" ${distr_list}
fi

echodat=`date`
echo "check databases ${db_nm} on ${loghostname} finished at ${echodat}"
