#!/bin/bash
# This cripts will run check of warning and critical levels of tables in redshift cluster.
# It will accept two parameters  Warling level percentage and another is Critical level percentage 
# It will send email with alert (with level warning or critical ) 
# In case of any issue please write to csingh1@cablevision.com

redshiftdetails="redshift-id-pass"
filename="$PWD/$redshiftdetails"
echo 
declare -a myArray
myArray=( `cat "$filename"`)
CUT=`which cut`

if [ "$#" -ne 2 ];
   then echo "USAGE : $0 'TABLES_THRESHOLD_WARNING_PERCENTAGE' 'TABLES_THRESHOLD_CRITICAL_PERCENTAGE '"
        echo " For Example : -"
        echo "  $0 75 90 "
        exit 1
fi

while IFS=$':' read -r -a myArray
do
    echo "Cluster name :" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "Database Name :" "${myArray[2]}" "Percentage of Tables : Warling level : $1 Critical Level $2: Cluster typei: ${myArray[5]}" 
    "$PWD/tables_check.sh" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com"  "${myArray[1]}" "${myArray[2]}" "${myArray[3]}"  "${myArray[4]}" "$1" "$2" "${myArray[5]}" 
done < "$filename" 
