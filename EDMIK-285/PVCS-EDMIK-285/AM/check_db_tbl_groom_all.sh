#!/bin/ksh

if [ "$#" -ne 2 ]; then

    echo "======================================================================================"
    echo "Usage $0 /full/path/to/config/file email_1@domain.com,email_2@domain.com"

    echo "parameter 1 full path to configuration file"
    echo "parameter 2 distribution list"
    echo "======================================================================================"
    exit 1
fi

cfg_file=$1
distr_list=$2

alert_threshold=0


tmp_dir="."

if [ -n "${cfg_file}" ];then

nz_bin_dir="/nz/support/bin/"
n_z_bin="nz_groom"

#check if configuration file exists
if [ -e $cfg_file ];then

i=1
>${tmp_dir}/tmp_tbl_need__groom_all_.tmp
# while reading lines from conf file

while read fln
do

sdb=""
stbl=""

sdb=`echo $fln |cut -s -d';' -f1`
stbl=`echo $fln |cut -s -d';' -f2`

nz_bin_param=" $sdb $stbl -scan "

if [ -n "${sdb}" ]
then

${nz_bin_dir}/${n_z_bin} ${nz_bin_param} > ${tmp_dir}/tmp_check_db_groom_all_.tmp


ln_hdr=$(grep -n -m 1 "Name                                  Remaining Rows" ${tmp_dir}/tmp_check_db_groom_all_.tmp |cut -d: -f1)
cnt_ln=$(wc -l ${tmp_dir}/tmp_check_db_groom_all_.tmp |cut -d\  -f1 )
st_ln=$(($cnt_ln-$ln_hdr-1))

echo "------------------------------------------------------------" >> ${tmp_dir}/tmp_tbl_need__groom_all_.tmp
echo "Database: $sdb $stbl" >> ${tmp_dir}/tmp_tbl_need__groom_all_.tmp
echo "------------------------------------------------------------" >> ${tmp_dir}/tmp_tbl_need__groom_all_.tmp

tail -n $st_ln ${tmp_dir}/tmp_check_db_groom_all_.tmp | awk -F" " '{ gsub(",","",$2); gsub(",","",$3); gsub(",","",$4); gsub(",","",$5);} { if ($4 > 0 && $4-$6 >0 ){sum_size+=$5;sum_rows+=$4   }}; END { print "Total reclaimable size:"sum_size";Total reclaimable rows:"sum_rows       }' >>${tmp_dir}/tmp_tbl_need__groom_all_.tmp

echo "------------------------------------------------------------" >> ${tmp_dir}/tmp_tbl_need__groom_all_.tmp

echo "Name;Remaining Rows;Remaining Size;Reclaimable Rows;Reclaimable Size;NON-Groomable Rows" >> ${tmp_dir}/tmp_tbl_need__groom_all_.tmp

tail -n $st_ln ${tmp_dir}/tmp_check_db_groom_all_.tmp | awk -F" " '{ gsub(",","",$2); gsub(",","",$3); gsub(",","",$4); gsub(",","",$5);} { if ($4 > 0 && $4-$6 >0 ){ print $1";"$2";"$3";"$4";"$5";"$6} }' | sort -t\; -n -r -k5 >> ${tmp_dir}/tmp_tbl_need__groom_all_.tmp

fi

done < $cfg_file

ch_rc_size=$(grep "Total reclaimable size" ${tmp_dir}/tmp_tbl_need__groom_all_.tmp | awk -F: '{ if ($2>0) { print $2 } }' |cut -d\; -f1 |wc -l |cut -d\  -f1)

if [ "$ch_rc_size" -gt 0 ]
then
    cat ${tmp_dir}/tmp_tbl_need__groom_all_.tmp | mailx -s "List of tables need to be groomed records all" $distr_list
fi

cat ${tmp_dir}/tmp_tbl_need__groom_all_.tmp

fi

fi

rm -f ${tmp_dir}/tmp_check_db_groom_all_.tmp
rm -f ${tmp_dir}/tmp_tbl_need__groom_all_.tmp
