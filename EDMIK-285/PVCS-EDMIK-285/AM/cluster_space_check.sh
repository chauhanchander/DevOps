#!/bin/bash
# This cripts will run check of total tables sizes in given schema ( input parameter schema_name) and depends on input parameter type_of_report.
# The script accepts following parameters
# host *, *port, database_name, schema_name *, threshold_warning_percentage ,threshold_critical , *type_of_report (report or alert ) , rs_user_name, rs_user_password )
# It will send email with alert (with level warning or critical ) or email with report
# In case of any issue please write to csingh1@cablevision.com

export PWD='/appbisam/DBA/scripts'
export SERVER_NAME="$1"
export SERVER_PORT="$2"
export DB_NAME="$3"
export SCHEMA_NAME="$4"
export THRESHOLD=9900
export CRITICAL_PERCENTAGE="$5"
export WARNING_PERCENTAGE="$6"
export TYPE_OF_REPORT="$7"
export USER_NAME="$8"
export PASS_WORD="$9"
export PSQL=`which psql`
export AWK=`which awk`
export SERVER_PORT="${10}"
export PGPASSWORD="$PASS_WORD"
export CAT=`which cat`
export MAILER=`which mail`
export TAIL=`which tail`
export CUT=`which cut`
export THRESHOLD=9900
export filename="$PWD/redshift-id-space-pass"


case "$1" in
    'all' | 'ALL' | 'All' )
        if [ "$#" -eq 1 ];then
            declare -a myArray
            myArray=( `cat "$filename"`)
            while IFS=$':' read -r -a myArray
            do
                echo "$0" "Server_Name, rs_user_name, rs_user_password, database_name, port_number, schema_name, threshold_warning_percentage"
                echo "$0" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "${myArray[1]}" "${myArray[2]}" "${myArray[3]}" "${myArray[4]}" "${myArray[5]}" "${myArray[6]}"
                "$PWD/space_check.sh" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "${myArray[1]}" "${myArray[2]}" "${myArray[3]}" "${myArray[4]}" "${myArray[5]}" "${myArray[6]}"
            done < "$filename"
        else
            echo  "USAGE : $0 ALL schema_name"
        fi;;
     *)
        if [ "$#" -eq 7 ];then
            "$PWD/space_check.sh" "$1"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}"
        else
            echo "To check space usage of one cluster:-"
            echo " "
            echo "USAGE : $0" 'Host_Name *, rs_user_name, rs_user_password, database_name, port_number, schema_name, threshold_warning_percentage '
            echo "or"
            echo "To check all the clusters mentioned in config files"
            echo "USAGE : $0 ALL"
            exit 1
        fi;;
esac

