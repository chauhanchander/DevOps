#!/bin/bash

filename="redshift-server_id-pass_prod"
declare -a myArray
myArray=( `cat "$filename"`)
CUT=`which cut`

if [ "$#" -ne 1 ];
   then echo "USAGE : $0 'enable/disable'"
        echo " For Example : -"
        echo " $0  enable or $0 disable"
        exit 1
fi

while IFS=$':' read -r -a myArray
do
    echo "Cluster name :" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "Database Name :" "${myArray[2]}" "User's option: $1"
    "$PWD/enable_disable.sh" "${myArray[0]}"\."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com" "${myArray[1]}" "${myArray[2]}" "${myArray[3]}" "${myArray[4]}" "$1"
done < "$filename"