#!/bin/bash -x
# This script will send an email for total space used
export CAT=`which cat`
export MAILFILE="/tmp/mailviews"
export MAILER=`which mail`
export MAIL_TO="csingh1@cablevision.com"
export FROM="Space_watcher@cablevision.com"

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


echo -n "Hello ${6}
Attached is report for AM/CMS ${1} space report for the ${2} database and ${3} Schema. The Total size of schema ${3} is ${7}.
Please review your objects and remove any unnecessary to preserve free space on the Redshift Cluster.

Thanks
Admin Team" >${MAILFILE}

$CAT $MAILFILE | $MAILER -s " AM/CMS WORKMSMGR (CVRSAMP) Space Report for ${1}" -r "$FROM" "${attargs[@]}"  "$MAIL_TO"

