#!/bin/bash
# This script will send an email for total number of tables 
# In Case of any issue please write to csingh1@cablevision.com


CAT=`which cat`
MAILFILE=/tmp/tablemailviews
MAILER=`which mail`
#The email id to open a ticket
MAIL_TO='EDMStrategicDBServices@cablevision.com'

#./email_users_for_tables.sh  "$MESSAGE" "$SERVER_NAME" "$SERVER_PORT" "$DB_NAME" "$THRESHOLD" "$Total_tables"
if [ "$#" -ne 7 ];
   then echo "USAGE : $0 MESSAGE CLUSTER_NAME  SERVER_PORT DATABASE_NAME TOTAL_TABLES TOTAL_TABLES_USED SERVER_TYPE"
        echo " For Example : -"
        echo " $0 $CLUSTER_NAME 'Cluster_Name' 'Server_Port' 'Database_name' 'Total_Tables' 'Total_tables_used' 'server_type'"
        exit 1
fi

echo -n "Hello Team,

Your are requested to clean the Tables from Red Shift ${7} Cluster Name: "$2"  . It has already consumed "$6" tables Out of "$5" .

Please drop / delete your all unwanted tables from Red shift DEV DB and purge. Let me know if you need any help or have any questions,

The details are following 

Cluster Type  =  "$7"
REDSHIFT_DBHOST= "$1"
REDSHIFT_DBPORT= "$2" 
REDSHIFT_DBNAME= "$3" 

The Redshift Cluster has total limit of "$5" and it has already consumed Total of "$6" Tables. Please do the needful.

Thanks 
Admin Team
" > $MAILFILE

$CAT $MAILFILE | $MAILER -s "${1}: ${7} Cluster ${2} is using ${6} out of ${5}" -r 'Cluster-Watch@cablevision.com' -b 'csingh1@cablevision.com' "$MAIL_TO"  
