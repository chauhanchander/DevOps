#!/bin/bash

filename=redshift-id-pass
declare -a myArray
myArray=( `cat "$filename"`)
CUT=`which cut`
if [ "$#" -ne 1 ];
   then echo "USAGE : $0 THRESHOLD_PERCENTAGE $7"
        echo " For Example : -"
        echo "  $0 Threshold_Percentage "
        exit 1
fi


while IFS=$':' read -r -a myArray
do
 echo "Cluster name :" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "Database Name :" "${myArray[2]}"
 ./space_check.sh "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" 'csingh1' "${myArray[1]}" "${myArray[2]}" "${myArray[3]}" "$1"
done < "$filename"

