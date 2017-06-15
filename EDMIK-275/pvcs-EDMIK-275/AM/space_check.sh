#!/bin/bash -x
# Shell script to monitor the usage of space in Redshift Cluster
# It will send an email to list defind in file, if the threshold crosses a limit
# If you have any suggestion or question please email to csingh1@cablevision.com

export PWD='/appbisam/DBA/scripts'
export SERVER_NAME="${1}"
export CAT=`which cat`
export USER_NAME="${2}"
export PASS_WORD="${3}"
export DB_NAME="${4}"
export PSQL=`which psql`
export AWK=`which awk`
export SERVER_PORT="${5}"
export MAIL=`which mail`
export PGPASSWORD="$PASS_WORD"
export CAT=`which cat`
export MAILFILE="/tmp/mailviews"
export MAILER=`which mail`
export TAIL=`which tail`
export CUT=`which cut`
export THRESHOLD="${7}"
export SCHEMA_NAME="${6}"
export SED=`which sed`
export CHMOD=`which chmod`
export MKDIR=`which mkdir`
export HEAD=`which head`
export MV=`which mv`
export PASTE=`which paste`
export COLUMN=`which column`
export LOGS_DIR="$PWD/SERVER_LOGS"
export COPY=`which cp`
export ECHO=`which echo`


"$MKDIR"  -p "$LOGS_DIR"
"$CHMOD" -R 755  "$LOGS_DIR"

sql_creation_for_schema(){
    export MOVE=`which mv`
    if [ -e "${PWD}/spacecheck.sql.bak" ];then
        export FILESQL=`$MOVE ${PWD}/spacecheck.sql.bak ${PWD}/spacecheck.sql`
    fi
    export CREAT_SQL_SCHEMA_CHECK=`${SED} -i.bak "s/workmsmgr/$1/g" ${PWD}/spacecheck.sql`

    if [ -e "${PWD}/schemasizecheck.sql.bak" ];then
        export SEHEMAFILESQL=`$MOVE ${PWD}/spacecheck.sql.bak ${PWD}/spacecheck.sql`
    fi
    export CREATE_SCHEMA_SIZE=`${SED} -i.bak "s/workmsmgr/$1/g" ${PWD}/schemasizecheck.sql`

    }


if [ ! -d "$PWD/SQLBACKUP" ];then
    export createdir=`$MKDIR -p ${PWD}/SQLBACKUP`
    export changemod=`$CHMOD -R 755 ${PWD}/SQLBACKUP`
fi

if [ "$#" -ne 7 ];
   then echo "USAGE : $0 SERVERNAME USERNAME PASSWORD DBNAME SERVER_PORT THRESHOLD SCHEMA_NAME"
        echo " For Example : -"
        echo "  $0 rsamd1.czfsgsdwh1wy.us-east-1.redshift.amazonaws.com 'user_name' 'pass_word' 'db_name' server_port space_threshold schema_name"
        exit 1
fi



export TOTAL_SIZE_PERCENTAGE=`"$PSQL" -h "$SERVER_NAME" -p "$SERVER_PORT" -U "$USER_NAME" -d "$DB_NAME" << EOF
select
    sum(capacity)/1024 as capacity_gbytes,
    sum(used)/1024 as used_gbytes,
    round(sum(used)/sum(capacity)::numeric *100,2) as pcnt_space,
   (sum(capacity) - sum(used))/1024 as free_gbytes
from
    stv_partitions where part_begin=0
EOF`

SIZE_USED_PERCENTAGE=`echo "$TOTAL_SIZE_PERCENTAGE" | "$AWK" '{print $5}'|"$TAIL" -n2|"$CUT" -d'.' -f1`
TOTAL_CLUSTER_SPACE=`echo "$TOTAL_SIZE_PERCENTAGE" | "$AWK" '{print $1}'|"$TAIL" -n2|"$CUT" -d'.' -f1`
TOTAL_SPACE_USED=`echo "$TOTAL_SIZE_PERCENTAGE" | "$AWK" '{print $3}'|"$TAIL" -n2|"$CUT" -d'.' -f1`

echo "The Total cluster capacity is $TOTAL_CLUSTER_SPACE GB"
echo "The used Cluster space is $TOTAL_SPACE_USED GB"



echo "The total used percentage is $SIZE_USED_PERCENTAGE"

echo "The threshold is $THRESHOLD"


if  [ "$SIZE_USED_PERCENTAGE" -gt "$THRESHOLD" ];then
    echo "Percentage is crossing threshold"
    sql_creation_for_schema "$6"
    export CHECK_SPACE=`"$PSQL" -h "$SERVER_NAME" -p "$SERVER_PORT" -U "$USER_NAME" -d "$DB_NAME" --file="$PWD/spacecheck.sql" > "$LOGS_DIR/$1.sqloutput"`
    export TOTAL_SIZE_OF_SCHEMA=`"$PSQL" -h "$SERVER_NAME" -p "$SERVER_PORT" -U "$USER_NAME" -d "$DB_NAME" --file="$PWD/schemasizecheck.sql" > "$LOGS_DIR/$1.$6.schemasize"`
    export REMOVE_TOP_LINES_OF_SCHEMA=`$CAT "$LOGS_DIR/$1.$6.schemasize"|$SED '1,2d'|$SED '/^\s*$/d'|$AWK '{print $3}' > "$LOGS_DIR/$1.$6.schemasize.clean"`
    export TOTAL_SIZE_OF_SCHEMA=`$CAT "$LOGS_DIR/$1.$6.schemasize.clean"`
    echo "The total Size of Schema is $TOTAL_SIZE_OF_SCHEMA"
    REMOVE_TOP_LINES=`$CAT "$LOGS_DIR/$1.sqloutput"|$SED '1,2d'|$AWK '{print $9}' > "$LOGS_DIR/$1.sqloutput.records"`
    REMOVE_BLANK_LINES=`$CAT "$LOGS_DIR/$1.sqloutput.records"|$SED '/^\s*$/d' > "$LOGS_DIR/$1.sqloutput.updated"`
    TABLE_NAME=`$CAT "$LOGS_DIR/$1.sqloutput"|$SED '1,2d'|$AWK '{print $5}' > "$LOGS_DIR/$1.tablename"`
    TABLE_NAME=`$CAT "$LOGS_DIR/$1.tablename"|$SED '/^\s*$/d' > "$LOGS_DIR/$1.tablename.clean"`
    TABLE_NAME=`$MV "$LOGS_DIR/$1.tablename.clean"  "$LOGS_DIR/$1.tablename"`
    SCHEMA_NAME=`$CAT "$LOGS_DIR/$1.sqloutput"|$SED '1,2d'|$AWK '{print $7}' > "$LOGS_DIR/$1.schemaname"`
    SCHEMA_NAME=`$CAT "$LOGS_DIR/$1.schemaname"|$SED '/^\s*$/d' > "$LOGS_DIR/$1.schemaname.clean"`
    SCHEMA_NAME=`$MV "$LOGS_DIR/$1.schemaname.clean"  "$LOGS_DIR/$1.schemaname"`
    TOTAL_TABLE_SPACE_GB=`$CAT "$LOGS_DIR/$1.sqloutput"|$SED '1,2d'|$AWK '{print $17}' > "$LOGS_DIR/$1.tablespaceingb"`
    TOTAL_TABLE_SPACE_GB=`$CAT "$LOGS_DIR/$1.tablespaceingb"|$SED '/^\s*$/d' > "$LOGS_DIR/$1.tablespaceingb.clean"`
    TOTAL_TABLE_SPACE_GB=`$MV "$LOGS_DIR/$1.tablespaceingb.clean" "$LOGS_DIR/$1.tablespaceingb"`
    TOTAL_TABLE_SPACE_BYTES=`$CAT "$LOGS_DIR/$1.sqloutput"|$SED '1,2d'|$AWK '{print $19}'  > "$LOGS_DIR/$1.tablespaceinbytes"`
    TOTAL_TABLE_SPACE_BYTES=`$CAT "$LOGS_DIR/$1.tablespaceinbytes"|$SED '/^\s*$/d' > "$LOGS_DIR/$1.tablespaceinbytes.clean"`
    TOTAL_TABLE_SPACE_GB=`$MV "$LOGS_DIR/$1.tablespaceinbytes.clean"  "$LOGS_DIR/$1.tablespaceinbytes"`
#    UNIQUE_RECORDS=`$AWK '{!seen[$0]++};END{for(i in seen) if(seen[i]==1)print i}' $1.sqloutput.new > $1.sqloutput.uniquerec`
    COUNT_RECORDS_FOR_ID=`$CAT "$LOGS_DIR/$1.sqloutput.updated"|/usr/bin/uniq -c > "$LOGS_DIR/$1.sqloutput.uniq"`
#    COUNT_TOTAL_RECORDS_IN_FILE=`$CAT  "$LOGS_DIR/$1.sqloutput.uniq" |/usr/bin/wc -l > "$LOGS_DIR/$1.sqloutput.wc"`

#  Creating CSV file

  CREATE_JOINT_FILE=`$PASTE -d, "$LOGS_DIR/$1.sqloutput.updated" "$LOGS_DIR/$1.tablename" "$LOGS_DIR/$1.schemaname" "$LOGS_DIR/$1.tablespaceingb" "$LOGS_DIR/$1.tablespaceinbytes" |$COLUMN -s $'\t' -t > "$LOGS_DIR/$1.table_information.csv"`

  # Insert the heading
  INSERT_HEADING=`"$SED" -i 1i"User_Name,Table_Name,Schema_Name,Total_Space_in_GB,Total_space_in_Bytes" "$LOGS_DIR/$1.table_information.csv"`

  CREATE_TEXT_FILE=`$PASTE "$LOGS_DIR/$1.sqloutput.updated" "$LOGS_DIR/$1.tablename" "$LOGS_DIR/$1.schemaname" "$LOGS_DIR/$1.tablespaceingb" "$LOGS_DIR/$1.tablespaceinbytes" |$COLUMN -s $'\t' -t > "$LOGS_DIR/$1.table_information.txt"`




    while IFS=$' ' read -r -a myRecArray
    do
       #echo "Separating ${myRecArray[0]} numbers of records from  $LOGS_DIR/$1.sqloutput.rec"
       #echo "$HEAD -"${myRecArray[0]}"  $LOGS_DIR/$1.sqloutput.updated > $LOGS_DIR/${myRecArray[1]}.$1.sqloutput.rec"
        echo "Separating ${myRecArray[0]} numbers of records from  $LOGS_DIR/$1.table_information.txt"
        echo "$HEAD" -"${myRecArray[0]}" "$LOGS_DIR/$1.table_information.txt"  > "$LOGS_DIR/${myRecArray[1]}.$1.report"
        #RECORD_SEPARATION_FOR_EMAIL=`$HEAD -"${myRecArray[0]}"  "$LOGS_DIR/$1.sqloutput.updated" > "$LOGS_DIR/${myRecArray[1]}.$1.rec"`
        RECORD_SEPARATION_FOR_EMAIL=`"$HEAD" -"${myRecArray[0]}" "$LOGS_DIR/$1.table_information.txt" > "$LOGS_DIR/${myRecArray[1]}.${1}.report.txt"`
        echo "$RECORD_SEPARATION_FOR_EMAIL"
       # Converting the user's specific report to csv
        total_space=0
        count=0
        while read value; do
            read -r -a linecontent <<< "$value"
            echo "${linecontent[0]},${linecontent[1]},${linecontent[2]},${linecontent[3]},${linecontent[4]}"
            #calculating the total space used by user
            let total_space=total_space+${linecontent[3]}
        done < "$LOGS_DIR/${myRecArray[1]}.${1}.report.txt" > "$LOGS_DIR/${myRecArray[1]}.${1}.report.csv"
       INSERT_REPORT_HEADING=`"$SED" -i 1i"User_Name,Table_Name,Schema_Name,Total_Space_in_GB,Total_space_in_Bytes" "$LOGS_DIR/${myRecArray[1]}.${1}.report.csv"`
       INSERT_SPACE_REPORT=`"$ECHO" ", ,Total Space Used,${total_space}" >> "$LOGS_DIR/${myRecArray[1]}.${1}.report.csv"`
       export SCHEMA_CALCULATION_IN_GB=`echo $((TOTAL_SIZE_OF_SCHEMA))`
       echo "This is total in GB ${SCHEMA_CALCULATION_IN_GB}"
       INSERT_SCHEMA_SIZE=`"$ECHO" ", ,Schema_Size,${SCHEMA_CALCULATION_IN_GB}" >> "$LOGS_DIR/${myRecArray[1]}.${1}.report.csv"`
       # echo "Removing ${myRecArray[0]} records from file $LOGS_DIR/$1.sqloutput.updated"
       # echo "$SED -i "1,${myRecArray[0]}d" $LOGS_DIR/$1.sqloutput.updated"
       # REMOVE_FROM_FILE=`$SED -i "1,${myRecArray[0]}d" "$LOGS_DIR/$1.sqloutput.updated"`
       echo  "Removing ${myRecArray[0]} records from file $LOGS_DIR/$LOGS_DIR/$1.table_information.txt"
       echo "$SED" -i "1,${myRecArray[0]}d" "$LOGS_DIR/$1.table_information.txt"
       REMOVE_FROM_FILE=`${SED} -i "1,${myRecArray[0]}d" "$LOGS_DIR/$1.table_information.txt"`
        echo $REMOVE_FROM_FILE
        # send an email
        echo "send an email"
        if [ ${TOTAL_SIZE_OF_SCHEMA} ]; then
            SEND_EMAIL_TO_USER=`"$PWD/email_users_for_space.sh"  "$1" "$4" "$6" "$LOGS_DIR/$1.table_information.csv" "$LOGS_DIR/${myRecArray[1]}.$1.report.csv" "${myRecArray[1]}" "${TOTAL_SIZE_OF_SCHEMA}"`
        else
            TOTAL_SIZE_OF_SCHEMA="00"
            SEND_EMAIL_TO_USER=`"$PWD/email_users_for_space.sh"  "$1" "$4" "$6" "$LOGS_DIR/$1.table_information.csv" "$LOGS_DIR/${myRecArray[1]}.$1.report.csv" "${myRecArray[1]}" "${TOTAL_SIZE_OF_SCHEMA}"`
        fi
    done < "$LOGS_DIR/$1.sqloutput.uniq"

fi
