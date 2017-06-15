#!/bin/bash

pg_host=$1
pg_port=$2
pg_user=$3
pg_password="$4"
pg_db=$5
v_schema_list="$6"

#v_schema_list="amperfmgr amstgmgr"
rds_id=$(echo $pg_host |awk -F"." ' { print $1 } ')
psqlbin="/app-am/edm/postgres/bin/"

for i in $v_schema_list
do

export PGPASSWORD="$pg_password"

${psqlbin}/pg_dump --host $pg_host  --port $pg_port --username $pg_user --no-password  --format plain --schema-only --verbose --file "${rds_id}_${pg_db}_${i}_sturcture_only.backup" --schema $i $pg_db 2> ${rds_id}_${pg_db}_${i}_sturcture_only.err

done
