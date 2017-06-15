#!/bin/bash
# In case of any issue please write to csingh1@cablevision.com

export PWD='/appbisam/DBA/scripts'
export SERVER_NAME="$1"
export USER_NAME="$2"
export PASS_WORD="$3"
export DB_NAME="$4"
export SERVER_PORT="$5"
export SCHEMA_NAME="$6"
export THRESHOLD_PERCENTAGE="$7"
export PSQL=`which psql`
export AWK=`which awk`
export PGPASSWORD="$PASS_WORD"
export CAT=`which cat`
export MAILER=`which mail`
export TAIL=`which tail`
export CUT=`which cut`
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
