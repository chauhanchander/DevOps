#!/bin/bash
cd /export/home/nz
. ~/.bashrc_cvadmin

cfg_file=$1

args=$#
if [ $args -eq 0 ]
then
   echo "======================================================================================"
   echo "Usage $0 full_path_to_config_file"
   echo "======================================================================================"
   exit 1
fi


if [ -n "${cfg_file}" ];then

gen_stat_wrk_dir="/nz/support/bin/"
gen_stat_bin="nz_genstats"

loghostname=`hostname`
logfiledir="/export/home/nz/DBA/maint/Appworx/log"
echodat=`date`
logdate=`date +"%m-%d-%y_%H%M"`
logfile="${logfiledir}/${loghostname}_genstat_by_${logdate}.log"

echo "start run ${0} on ${loghostname} at ${echodat}" > ${logfile}

#check if configuration file exists
if [ -e "$cfg_file" ];then

echo "start of configuration file ${cfg_file} body" >> $logfile
cat ${cfg_file} >> ${logfile}
echo "end of configuration file ${cfg_file} body" >> $logfile

i=1
# while reading lines from conf file
while read fln
do

sdb=""
stbl=""
stattp=""

sdb=`echo $fln |cut -s -d';' -f1`
stbl=`echo $fln |cut -s -d';' -f2`
stattp=`echo $fln |cut -s -d';' -f3`


if [ -n "${sdb}" ] && [ -n "${stbl}" ];then 

r_ch=""
r_ch=`$gen_stat_wrk_dir/$gen_stat_bin $sdb $stbl -info |awk '/Database:/{x=NR+5}(NR<=x){print}' |tail -n 1 |cut -b69-` 

if [ -z "${r_ch}" ];then
	echo "parsing of $gen_stat_wrk_dir/$gen_stat_bin $sdb $stbl -info failed" >> $logfile
else
	#remove new line from output
	r_ch=$(echo $r_ch| tr -d '\n')
	cnt=0
	
	if [ "$r_ch" == "GENERATE EXPRESS STATISTICS ..." ];then
		if [ -n "${stattp}" ];then
			echo "start generate $stattp statistics on  $sdb $stbl" >> $logfile 2>&1
		else
			echo "start generate express statistics on  $sdb $stbl" >> $logfile 2>&1
			stattp="express"			
		fi
		$gen_stat_wrk_dir/$gen_stat_bin $sdb $stbl "-$stattp"  >> $logfile 2>&1
		((cnt++))
	fi
	if [ "$r_ch" == "GENERATE /*full*/ STATISTICS ..." ];then
		if [ -n "${stattp}" ];then
			echo "start generate $stattp statistics on  $sdb $stbl" >> $logfile 2>&1
		else
			echo "start generate full statistics on  $sdb $stbl" >> $logfile 2>&1
			stattp="full"
		fi
		#generate statistic
		$gen_stat_wrk_dir/$gen_stat_bin $sdb $stbl "-$stattp"  >> $logfile 2>&1
		((cnt++))
        fi
	if [ "$r_ch" == "GENERATE STATISTICS ..." ];then
		if [ -n "${stattp}" ];then
			echo "start generate $stattp statistics on  $sdb $stbl" >> $logfile 2>&1
		else		
	                echo "start generate statistics on  $sdb $stbl"  >> $logfile 2>&1
			stattp=""
		fi
                #generate statistic
                $gen_stat_wrk_dir/$gen_stat_bin $sdb $stbl "-$stattp">> $logfile 2>&1
                ((cnt++))
        fi
	
	if [ $cnt -eq 0 ];then
		echo "nothing to do $sdb $stbl,  check stats result ${r_ch} " >> $logfile 2>&1
	fi
fi

else
	echo "can't find dbname and table name from configuration file "$cfg_file" line $i"  >> $logfile 2>&1
fi
((i++))

done < $cfg_file

echodat=`date`
echo "run ${0} finished on ${loghostname} at ${echodat}" >> $logfile
exit 0

else
	echo "configuration file with tables list does not exists: $cfg_file" >> $logfile
	exit 1
fi
else
	echo "wrong input parameter, run script with input parameters filename that should contain comma separated list of database name, filename, statistic type" >> $logfile
        exit 2
fi

