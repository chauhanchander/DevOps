#!/bin/bash

cd /export/home/nz
. ~/.bashrc_cvadmin

if [ "$#" -ne 3 ]; then

    echo "======================================================================================"
    echo "Usage $0 \"dbname1:dbname2:dbname3\" 104857600 email_1@domain.com,email_2@domain.com"

    echo "parameter 1 list of databases"
    echo "parameter 2 alert_threshold - number in MB"
    echo "parameter 3 list of emails"

    echo "======================================================================================"
    exit 1
fi

dblist=$1
alert_threshold=$2
common_distr_list=$3

#################################
distr_domain="cablevision.com"
loghostname=`hostname`

#dblist="WORKDB:WORKMSDB" 
#alert_threshold=10

##bindir="./"
bindir="/nz/support/bin/"
dbsize_bin="nz_db_size"

#dbsize_opts=" 1"
dbsize_opts=" -summary -mb"

#logfiledir="log/"
logfiledir="/export/home/nz/DBA/maint/Appworx/log"
tmpdir_path="/tmp"

echodat=`date`
logdate=`date +"%m-%d-%y_%H%M"`

logfilename="chk_alert_size_db_${logdate}.log"
userlist_filename="chk_alert_user_list_${logdate}.tmp"

match=":"
repl=" -e "
grep_dbs=${dblist//$match/$repl}

grep_dbs="grep -e $grep_dbs"

chk_total_dbs_size=""
chk_total_dbs_size=$(${bindir}/${dbsize_bin} ${dbsize_opts} | ${grep_dbs} | awk -v atrv=$alert_threshold  -F"|" '{ gsub(",","",$3); a+=$3;}  END{ if ( a > atrv ) { print "alert_threshold_exceeded:"a } else {print "under_alert_threshold:"a } } ')

totaldbs_size=$(echo $chk_total_dbs_size| cut -d\: -f2)
chk_total_dbs_size=${chk_total_dbs_size/":$totaldbs_size"/""}

if [ "$chk_total_dbs_size" == "alert_threshold_exceeded" ]
then
        match=":"
        repl=" "
        fordblist=${dblist//$match/$repl}

        #remove old files from tmp
		
        rm -f ${tmpdir_path}/chk_alert_user_list_*.tmp
        rm -f ${tmpdir_path}/total_obj_sz_chk_alert_user_list_*.tmp

        >${logfiledir}/${logfilename}
        >${tmpdir_path}/${userlist_filename}

        for i in $fordblist
        do

        #dbsize_opts=" 2"
        dbsize_opts=" $i -detail -owners -mb"

                ${bindir}/${dbsize_bin} ${dbsize_opts} >> ${logfiledir}/${logfilename}
                cat ${logfiledir}/${logfilename} |  awk -v vdbname=$i -F"|" '{ gsub(",","",$3); a[$4]+=$3;}  END{ for(i in a) { if ( a[i] > 0 ) print vdbname"|"i"|"a[i];} }' >> ${tmpdir_path}/${userlist_filename}
        done

        distr_lst=$( cat ${tmpdir_path}/${userlist_filename} |  awk -v vdomain=${distr_domain} -F"|" '{ gsub(" ","",$2) ; if ( $2!="ADMIN" )  print $2"@"vdomain} ' |sort -u |awk  -F"|" ' {  a=a","$1  } END {print a }' )

        echo -e "DBNAME\tOWNER\tTOTAL MB" > ${tmpdir_path}/"total_obj_sz_"${userlist_filename}

        cat ${tmpdir_path}/${userlist_filename} | awk -F"|" ' { print $1"\t"$2"\t"$3 }'  >> ${tmpdir_path}/"total_obj_sz_"${userlist_filename}

        echo -e "                        " >> ${tmpdir_path}/"total_obj_sz_"${userlist_filename}
        echo "$echodat : Detailed statistic by DB/object below:" >> ${tmpdir_path}/"total_obj_sz_"${userlist_filename}
        echo "                        " >> ${tmpdir_path}/"total_obj_sz_"${userlist_filename}

		
       	distr_lst=${common_distr_list}${distr_lst}
	

        echo "$echodat alert threshold exceeded on $loghostname for databases $dblist total size = $totaldbs_size MB, emails will be send to list of users $distr_lst"

	#mail alerts to object owners and distribution list
        cat ${tmpdir_path}/"total_obj_sz_"${userlist_filename} ${logfiledir}/${logfilename} | /bin/mailx -s "alert threshold exceeded on $loghostname for databases $dblist total size = $totaldbs_size MB" ${distr_lst}

else
        echo "$echodat total databases $dblist size=$totaldbs_size Mb under threshold $alert_threshold"
fi

