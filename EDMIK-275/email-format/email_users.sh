#!/bin/bash
CAT=`which cat`
MAILFILE=/tmp/mailviews
MAILER=`which mail`
MAIL_TO="$4"

if [ "$#" -ne 7 ];
   then echo "USAGE : $0 CLUSTER_NAME  SERVER_PORT TOTAL_SPACE SPACE_USED SPACE_USED_PERCENTAGE THRESHOLD"
        echo " For Example : -"
        echo "  $0 rsamd1.czfsgsdwh1wy.us-east-1.redshift.amazonaws.com 'user_name' 'pass_word' 'db_name' server_port space_threshold"
        exit 1
fi



echo -n "Hello Team,

Your are requested to clean the Red Shift Cluster "$1". The total space is "$3"i and it has already consumed "$SPACE_USED_PERCENTAGE"% of space.

Please drop / delete your all unwanted tables from Red shift DEV DB and purge. Let me know if you need any help or have any questions,

The details are following


REDSHIFT_DBHOST= "$1"
REDSHIFT_DBPORT= "$2"
REDSHIFT_DBNAME= "$3"

Thanks
" > $MAILFILE

$CAT $MAILFILE | $MAILER -s "CPU Load is $CPU_LOAD % on ${HOSTNAME}" "$MAIL_TO"
