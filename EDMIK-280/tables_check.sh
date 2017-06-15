#!/bin/bash
# Shell script to monitor the number of tables in Redshift Cluster
# It will send an email to list defind in file, if the threshold crosses a limit
# If you have any suggestion or question please email to csingh1@cablevision.com


export SERVER_NAME="$1"
export USER_NAME="$2"
export PASS_WORD="$3"
export DB_NAME="$4"
export PSQL=`which psql`
export AWK=`which awk`
export SERVER_PORT="$5"
export PGPASSWORD="$PASS_WORD"
export CAT=`which cat`
export MAILER=`which mail`
export TAIL=`which tail`
export CUT=`which cut`
export THRESHOLD=9900
export CRITICAL_PERCENTAGE="$7"
export WARNING_PERCENTAGE="$6"
export SERVER_TYPE="$8"
export FIRSTLIMIT=$(/bin/awk "BEGIN { pc=${WARNING_PERCENTAGE}/100*${THRESHOLD}; i=int(pc); print (pc-i<0.5)?i:i+1 }") 
export CRITICALLIMIT=$(/bin/awk "BEGIN { pc=${CRITICAL_PERCENTAGE}/100*${THRESHOLD}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

echo "The First limit is $FIRSTLIMIT"

echo "The Critical limit is $CRITICALLIMIT"


if [ "$#" -ne 8 ]; 
   then echo "USAGE : $0 SERVERNAME USERNAME PASSWORD DBNAME SERVER_PORT TABLES_WARNING_PERCENTAGE TABLES_CRITICAL_LIMIT SERVER_TYPE"
        echo " For Example : -"
        echo "  $0 rsamd1.czfsgsdwh1wy.us-east-1.redshift.amazonaws.com 'user_name' 'pass_word' 'db_name' server_port tables_warning_limit tables_critical_limit production"
        exit 1
fi

Number_of_User_defined_tables=`"$PSQL" -h "$SERVER_NAME" -p "$SERVER_PORT" -U "$USER_NAME" -d "$DB_NAME" -t -c "select count(distinct name) from stv_tbl_perm"`
Number_of_Transient_tables=`"$PSQL" -h "$SERVER_NAME" -p "$SERVER_PORT" -U "$USER_NAME" -d "$DB_NAME" -t -c " select count(distinct id) from stv_tbl_trans"`

Total_tables=$((Number_of_User_defined_tables+Number_of_Transient_tables))


echo "The Total tables are $Total_tables"


    if  [ "0$Total_tables" -lt "0$CRITICALLIMIT" ]  && [ "0$Total_tables" -gt "0$FIRSTLIMIT" ]
    then
         MESSAGE="Warning" 
         echo "$MESSAGE"
         "$PWD/email_users_for_tables_warninglevel.sh" "$MESSAGE" "$SERVER_NAME" "$SERVER_PORT" "$DB_NAME" "$THRESHOLD" "$Total_tables" "$SERVER_TYPE" 
    elif [ "0$Total_tables" -gt "0$CRITICALLIMIT" ] && [ "0$Total_tables" -lt "0$THRESHOLD" ]
    then
         MESSAGE="Critical"
         "$PWD/email_users_for_tables_criticallevel.sh"  "$MESSAGE" "$SERVER_NAME" "$SERVER_PORT" "$DB_NAME" "$THRESHOLD" "$Total_tables" "$SERVER_TYPE"
         echo "$MESSAGE"
    elif  [ "0$Total_tables" -eq "0$THRESHOLD" ]
    then 
        MESSAGE="Limit finished"
        "$PWD/email_users_for_tables_criticallevel.sh"  "$MESSAGE" "$SERVER_NAME" "$SERVER_PORT" "$DB_NAME" "$THRESHOLD" "$Total_tables" "$SERVER_TYPE"
        echo "$MESSAGE"
    else
        MESSAGE="All Ok"
    fi

echo " The Table condition is $MESSAGE"

