#!/bin/bash

cd /export/home/nz
. ~/.bashrc_cvadmin

args=$#
if [ $args -lt 2 ]
then
   echo "======================================================================================"
   echo "Usage $0 dbname tblname genstat_type"
   echo "======================================================================================"
   exit 1
fi

dbname=$1
tblname=$2
genstat_type=$3
size_type=${#genstat_type} 

if [ "$size_type" -ge 4 ] 
then
	genstat_type="-$genstat_type"
	genstat_type=$(echo ${genstat_type} |awk '{print tolower($0)}')
fi

gen_stat_wrk_dir="/nz/support/bin/"
gen_stat_bin="nz_genstats"

loghostname=`hostname`
echodat=`date`

echo "start run ${0} on ${loghostname} at ${echodat}"
echo "start generate $genstat_type statistics on $loghostname $sdb $stbl at ${echodat}"

$gen_stat_wrk_dir/$gen_stat_bin ${dbname} ${tblname} ${genstat_type}

echodat=`date`
echo "run ${0} finished on $loghostname $sdb $stbl at ${echodat}"
