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
csingh1@cvluawsbisam1:/home/csingh1/EDMIK-285> cat enable_disable.sh
#!/bin/bash
# Shell script to enable disable the users from Redshift Cluster
# It will send an email to users if the email option is set on
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
export GREP=`which grep`

if [ "$#" -ne 6 ];
    then echo "USAGE : $0 SERVERNAME USERNAME PASSWORD DBNAME SERVER_PORT ENABLE  or USAGE : $0 SERVERNAME USERNAME PASSWORD DBNAME SERVER_PORT ENABLE/DISABLE"
        echo " For Example : -"
        echo "  $0 rsamd1.czfsgsdwh1wy.us-east-1.redshift.amazonaws.com 'user_name' 'pass_word' 'db_name' server_port 'enable/disable'i"
        exit 1
fi


case "$6" in
"enable" )
    export FILEPATH="$PWD/enable_users_list.sql"
    export enable='yes';;
"disable" )
     export FILEPATH="$PWD/disable_users_list.sql"
     export disable='yes';;

"*" )
     echo " Please enter command as following :-"
     echo " $0 rsamd1.czfsgsdwh1wy.us-east-1.redshift.amazonaws.com 'user_name' 'pass_word' 'db_name' server_port 'enable/disable'"
     exit 1;;
esac


while IFS= read -r line ; do
    echo "The line is $line"
    USER=`echo $line|$AWK '{ print $3 }'`
    echo  "The user name is $USER"
    CHECK_USER=`"$PSQL" -h "$SERVER_NAME" -p "$SERVER_PORT" -U "$USER_NAME" -d "$DB_NAME" -t -c "select usename from pg_user";`
    USER_EXIST=`echo "$CHECK_USER"|"$GREP" "$USER"`
    if [ "$USER_EXIST" ];then
        echo "The status of user is $USER_EXIST" >> "$PWD/listofusers"
        echo "Running ...."
        echo "$PSQL -h $SERVER_NAME -p $SERVER_PORT -U $USER_NAME" -d $DB_NAME -t -c "$line"
        echo "Connecting...."
        export ENABLE_DISABLE_USERS=`"$PSQL" -h "$SERVER_NAME" -p "$SERVER_PORT" -U "$USER_NAME" -d "$DB_NAME" -t -c "$line"\;`
        echo "The output for $USER_NAME is $ENABLE_DISABLE_USERS"
           if [ "$enable" ];then
              echo "$ENABLE_DISABLE_USERS" >> "$PWD/enableusers.log"
              echo " User $USER enabled in $SERVER_NAME " >> "$PWD/enableusers.log"
           fi
           if [ "$disable" ];then
              echo "$ENABLE_DISABLE_USERS" >> "$PWD/disableusers.log"
              echo " User $USER disabled in $SERVER_NAME " >> "$PWD/disableusers.log"
           fi
    else
        echo "continue.."
    fi
done< "$FILEPATH"
