#!/bin/bash
# This cripts will run check of total tables sizes in given schema ( input parameter schema_name) and depends on input parameter type_of_report.
# The script accepts following parameters
# host *, *port, database_name, schema_name *, threshold_warning_percentage ,*type_of_report (report or alert ) , rs_user_name, rs_user_password )
# or you can select 'all' option to run it against all the clusters mentioned in redshift-id-pass
# It will send an alter email with report to user
# In case of any issue please write to csingh1@cablevision.com

export CLUSTER_NAME="$1"
export USER_NAME="$2"
export USER_PASSWORD="$3"
export DB_NAME=$4
export SERVER_PORT="$5"
export SCHEMA_NAME="$6"
export PSQL=`which psql`
export AWK=`which awk`
export PGPASSWORD="$PASS_WORD"
export CAT=`which cat`
export MAILER=`which mail`
export TAIL=`which tail`
export CUT=`which cut`
export PWD="/appbisam/DBA/scripts"
export SERVER_ID_PASS_FILENAME="$PWD/clusters-id-pass"


case "$1" in
    'all' | 'ALL' | 'All' )
        if [ "$#" -eq 1 ];then
            declare -a myArray
            myArray=( `cat "$filename"`)
            while IFS=$':' read -r -a myArray
            do
                echo "$0" "Server_Name, rs_user_name, rs_user_password, database_name, port_number, schema_name"
                echo "$0" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "${myArray[1]}" "${myArray[2]}" "${myArray[3]}" "${myArray[4]}" "${myArray[5]}"
                "$PWD/cluster_schema_space_check.sh" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "${myArray[1]}" "${myArray[2]}" "${myArray[3]}" "${myArray[4]}" "${myArray[5]}"
            done < "$SERVER_ID_PASS_FILENAME"
        else
            echo  "USAGE : $0 ALL schema_name"
        fi;;
     *)
        if [ "$#" -eq 6 ];then
            "$PWD/cluster_schema_space_check.sh" "$1"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "${2}" "${3}" "${4}" "${5}" "${6}"
        else
            echo "To Check and generate schema space usage of one cluster:-"
            echo " "
            echo "USAGE : $0" 'Host_Name *, rs_user_name, rs_user_password, database_name, port_number, schema_name '
            echo "or"
            echo "To check and generate schema space usage of all the clusters mentioned in config file"
            echo "USAGE : $0 ALL"
            exit 1
        fi;;
esac
