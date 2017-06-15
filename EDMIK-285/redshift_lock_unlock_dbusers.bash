#!/bin/bash -vx
# Shell script to enable disable the users from Redshift Cluster
# It will send an email to users if the email option is set on
# If you have any suggestion or question please email to csingh1@cablevision.com

export SERVER_NAME="$2"."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com"
export SERVER_PORT="$3"
export DB_NAME="$4"
export USER_NAME="$5"
export PASS_WORD="$6"
export PSQL=`which psql`
export AWK=`which awk`
export PGPASSWORD="$PASS_WORD"
export CAT=`which cat`
export MAILER=`which mail`
export TAIL=`which tail`
export GREP=`which grep`
export RUN_OPTION="$1"
export CUT=`which cut`
#export TODAY=`date "+%m%d%y_%H%M"`
export CLUSTER_ID="$2"
export CLUSTER_NAME="$2"."czfsgsdwh1wy.us-east-1.redshift.amazonaws.com"
export SED=`which sed`
export TR=`which tr`
export TODAY=$(date "+%Y.%m.%d-%H.%M.%S")
export MKDIR=`which mkdir`
export CHMOD=`which chmod`
export LN=`which ln`
# PWD set to constant due to Appworx way of working
export PWD='/appbisam/DBA/scripts'

# String of users to be excluded
#export EXCLUDE_USER=`sed "s/\(.*\)/'\1'/"  ${EXCLUDE_FILE}  | tr -s '\n' ',' | sed 's/,$//'`

if [ ! -d "$PWD/DISABLE_LOGS" ];then
    CREATE_LOGS=`$MKDIR -p "$PWD/DISABLE_LOGS"`
    DIR_PERM=`$CHMOD -R 755 "$PWD/DISABLE_LOGS"`
fi

if [ ! -d "PWD/ENABLE_LOGS" ];then
    CREATE_LOGS_DIR=`$MKDIR -p "$PWD/ENABLE_LOGS"`
    DIR_PERM=`$CHMOD -R 755 "$PWD/DISABLE_LOGS"`
fi

if [ "$#" -lt 6 ];
    then clear
        echo "USAGE examples "
        echo " $0 '<enable/disable>' 'redshift_host*, redshift_port ,redshift_db_name, redshift_superuser_name, redshift_superuser_password '"
        echo " "
        echo "For Example : - "
        echo " "
        echo "USAGE : $0 'enable' 'redshift_host*, redshift_port ,redshift_db_name, redshift_superuser_name, redshift_superuser_password rsamt1.Enable_latest_disabled_users.sql'"
        echo " "
        echo " "
        echo "or"
        echo " "
        echo "USAGE : $0 'disable' 'redshift_host*, redshift_port ,redshift_db_name, redshift_superuser_name, redshift_superuser_password'"
        echo " "
        echo " "
        exit 1
fi


case "$1" in
"disable" )
    export FILEPATH="$PWD/${CLUSTER_ID}_disable_exclude_users_list.prm"
    export SQL_FILE="$PWD/DISABLE_LOGS/${CLUSTER_ID}_alter_disable_users_list_${TODAY}.sql"
    export LOG_FILE="$PWD/DISABLE_LOGS/${CLUSTER_ID}_alter_disable_sql_run_${TODAY}.out"
    export ERR_FILE="$PWD/DISABLE_LOGS/${CLUSTER_ID}_alter_disable_sql_run_${TODAY}.err"
    export OUTFILE="$PWD/DISABLE_LOGS/${CLUSTER_ID}_disable_users_list_${TODAY}.out"
    export EXCLUDE_FILE="$PWD/${CLUSTER_ID}_disable_exclude_users_list.prm"
    export TEMP_FILE="$PWD/DISABLE_LOGS/${CLUSTER_ID}_disable_exclude_users_list_${TODAY}.tmp"
    touch "$TEMP_FILE"
    export disable='yes'
    # Checking the user
    if [ -e "$FILEPATH" ];then
        # Backup users which are to be disabled
        export EXCLUDE_USER=`"$SED" "s/\(.*\)/'\1'/"  ${EXCLUDE_FILE}  | "$TR" -s '\n' ',' | "$SED" 's/,$//'`
        echo "listing all the EXCLUDE users"
        echo "$EXCLUDE_USER"
        export SQL_BACKUP=`$PSQL -h ${CLUSTER_NAME} -p ${3} -U ${5} -d ${4} -F $'\t' --no-align -t -c "SELECT usename FROM pg_catalog.pg_user WHERE (valuntil >= abstime(current_timestamp) ) AND usename not in (${EXCLUDE_USER})" > ${OUTFILE}`
        echo "the output of sql command"
        echo "$SQL_BACKUP"
        echo  ${OUTFILE}
        # prepare SQL FILE FROM ${OUTFILE}
        # Prepare SQL file from Output file
        # prepare only valid accounts
        #SED_FILE=`$SED -n '1!p' ${OUTFILE} | $CUT -d$'\t' -f1 > ${SQL_FILE}`
        SED_FILE=`$CAT ${OUTFILE} | $CUT -d$'\t' -f1 > ${SQL_FILE}`
        SED_FILE2=`$SED -i 's/^/ALTER USER /g' ${SQL_FILE}`
        echo "$SED_FILE"
        echo "$SED_FILE2"
#        SED_FILE3=`$SED -i 's/^/VALID UNTIL \'1901-12-14 00:00:00\'; /g' ${SQL_FILE}`
        SED_FILE3=`$SED -e "s/$/ VALID UNTIL \'1901-12-14 00:00\'/" ${SQL_FILE} > ${TEMP_FILE}`
        # running command against database
        # Run commands against the database
        while IFS= read -r line ; do
            echo "$line"
            echo "The following command will run on server"
            echo "${PSQL} -h ${CLUSTER_NAME} -p ${3} -U ${5} -d ${4} -t -c "$line"" >> ${LOG_FILE}
            DISABLE_USERS=`${PSQL} -h ${CLUSTER_NAME} -p ${3} -U ${5} -d ${4} -t -c "$line"; 2>"${ERR_FILE}" 1>"${LOG_FILE}"`
            echo ${DISABLE_USERS}
            echo ${DISABLE_USERS} >>${LOG_FILE}
            echo "$line"
        done< "${TEMP_FILE}"
       # updating the link
       UPDATE_ENABLE_LINK=`$LN -sfn ${SQL_FILE} "$PWD/${2}.Enable_latest_disabled_users.sql"`
       echo "link Created .."
       echo "$UPDATE_ENABLE_LINK"
    else
        echo "The file $FILEPATH does not exist, please check" >> ${LOG_FILE}
        exit 1
    fi;;
"enable" )
    if [ $# -eq 7 ] && [ -e "$PWD/${7}" ];then
        export enable='yes'
        export LOG_FILE="$PWD/ENABLE_LOGS/${CLUSTER_ID}_alter_enable_sql_run_${TODAY}.out"
        touch ${LOG_FILE}
        export ERR_FILE="$PWD/ENABLE_LOGS/${CLUSTER_ID}_alter_enable_sql_run_${TODAY}.err"
        export OUTFILE="$PWD/ENABLE_LOGS/${CLUSTER_ID}_alter_enable_users_list_${TODAY}.out"
        export TEMP_FILE="$PWD/ENABLE_LOGS/${CLUSTER_ID}_alter_enable_exclude_users_list_${TODAY}.tmp"
        export OUTFILENEW="$PWD/ENABLE_LOGS/${CLUSTER_ID}_alter_enable_users_list_${TODAY}.out-updated"
        export CREATE_ENABLE_SQL_SED_FILE3=`$SED -e "s/$/ VALID UNTIL \'2024-01-19 00:00\'/" "$PWD/${7}" > ${TEMP_FILE}`
        while IFS= read -r line ; do
            echo "$line"
            ENABLE_USERS=`${PSQL} -h ${CLUSTER_NAME} -p ${3} -U ${5} -d ${4} -t -c "$line"; 2>"${ERR_FILE}" 1>"${LOG_FILE}"`
            echo ${ENABLE_USERS}
            echo ${ENABLE_USERS} >> ${LOG_FILE}
            echo "$line"
        done< "${TEMP_FILE}"
    else
        export LOG_FILE="$PWD/ENABLE_LOGS/${CLUSTER_ID}_alter_enable_sql_run_${TODAY}.out"
        echo "The SQL file $PWD/${7} does not exist, please check" >${LOG_FILE}
        exit 1
    fi;;
"*" )
     echo " Please enter enable or disable option "
     exit 1;;
esac
