#!/bin/bash
# This script will send an email for total space used
export PWD='/appbisam/DBA/scripts'
export filename="$PWD/redshift-id-space-pass"
export CAT=`which cat`
export MAILFILE="/tmp/spacemailviews"
export MAILER=`which mail`
export MAIL_TO="${6}@cablevision.com,csingh1@cablevision.com"
export FROM="RedShift_Space_Watcher@cablevision.com"

if [ "$#" -ne 7 ];
   then echo "USAGE : $0 CLUSTER_NAME DATABASE_NAME SCHEMA_NAME ALL_REPORT_NAME USER_REPORT_NAME USER_NAME TOTAL_SIZE_OF_SCHEMA"
        echo " For Example : -"
        echo "  $0 rsamd1.czfsgsdwh1wy.us-east-1.redshift.amazonaws.com 'Database_name' 'Database_Schema_name' 'All_Object_report' 'User_Object_report' 'User_name' 'Total_size_of_schema'"
        exit 1
fi

declare -a attachments
attachments=( "$4" "$5" )

declare -a attargs
for att in "${attachments[@]}"; do
  attargs+=( "-a"  "$att" )
done

USER_SCHEMA_SIZE=${7}
export calculate=`echo $((USER_SCHEMA_SIZE/1024))`
echo "This is total in GB $calculate"

echo -n "Hello ${6}


Attached is report for AM/CMS ${1} space report for the ${2} database and ${3} Schema. The Total size of schema ${3} is $calculate GB.
Please review your objects and remove any unnecessary to preserve free space on the Redshift Cluster.For objects not in your ownership, contact owner to remove.

For application owned objects, open a Service Request to EIT DB Services with AM/CMS management approval to remove the object


Thanks
Admin Team" >${MAILFILE}

$CAT $MAILFILE | $MAILER -s " AM/CMS ${3} ("$2") Space Report for ${1}" -r "$FROM" "${attargs[@]}"  "$MAIL_TO"
