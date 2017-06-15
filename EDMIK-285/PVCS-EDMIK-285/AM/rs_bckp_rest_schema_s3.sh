################################
#Author : Deepak Biswas ########
#Backup and Restore Script######
################################

#!/bin/bash -x


usage="$(basename "$0") [--help] [--backup --restore] -- program to backup and restore redshift cluster\n


\nwhere:\n
    --backup  is used to backup the schema
    example ./$(basename "$0") --backup <redshift_host> <port> <user> <password> <db> <schemaname> <s3_base_location> \n

    --restore  is used to restore the schema \n
    example ./$(basename "$0") --restore <redshift_host> <port> <user> <password> <db> <schemaname> <s3_base_location> \n

    Make sure : rsamp1d_user_privileges.out and rsamp1d_group_privileges.out files are present in present working directory present \n"



function log {

        echo "[`date '+%Y-%m-%d %T'`]:" $1 >> $log_dir/$log_file

}


host=$2
port=$3
user=$4
cvadmin_pass=$5
db=$6
schema=$7
s3_base=$8

clusterID=$(echo $host | cut -d\. -f1 |tr -d " ")

export PGPASSWORD='$cvadmin_pass'

log_dir='/appbisam/DBA/logs'
log_file="${clusterID}_${schema}_backup_restore.log"
tmp_dir='/tmp'
script_dir='/appbisam/DBA/scripts'


aws_key=AKIAJHFFZGPJD7S7ZT4Q
aws_secret=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


function extract_ddl {

        log "Exporting Table DDL to rsamp1d_tables_ddl.out"
        psql -t -h $host -p $port -U $user -d $db -c "SELECT ddl FROM $user.v_generate_tbl_ddl WHERE schemaname ='$schema';" > $log_dir/${clusterID}_${schema}_tables_ddl.out
        log "Exporting Views"
        psql -t -h $host -p $port -U $user -d $db -c "SELECT 'CREATE OR REPLACE VIEW '||schemaname||'.'||viewname||' AS '||definition as sq FROM pg_catalog.pg_views WHERE schemaname ='$schema' ORDER BY sq;" > $log_dir/${clusterID}_${schema}_views_ddl.out
        log "Exporting all the tables"
        psql -t -h $host -p $port -U $user -d $db -c "select schema||'.'||\"table\" as table_name FROM SVV_TABLE_INFO WHERE schema='$schema';" > $log_dir/${clusterID}_${schema}_tables_list.out
}


function upload_s3 {

	 psql -h $host -p $port -U $user -d $db -f $1 -a >> $log_dir/$log_file 2>>$log_dir/$log_file

}


function create_s3Sql {
	>$log_dir/${clusterID}_${schema}_tables_unload.sql
	while read table_name ; do
		if [[ $table_name == $schema* ]]
		then
			table=`echo $table_name | awk -F . '{gsub(/\n$/,"");print $2}'`
			schema=`echo $table_name | awk -F . '{gsub(/\n$/,"");print $1}'`
			echo "UNLOAD ('SELECT * FROM $table_name ') to 's3://$s3_base/$clusterID/$schema/$table/$table_name.gz' credentials 'aws_access_key_id=$aws_key;aws_secret_access_key=$aws_secret' gzip escape  allowoverwrite ;" >> $log_dir/${clusterID}_${schema}_tables_unload.sql
			#echo $table_name
		fi
	done < $log_dir/${clusterID}_${schema}_tables_list.out

}

function backup_users_privilleges {
	psql -h $host -p $port -U $user -d $db -f $1 -v sch_name="'$schema'" -t > $2 2>>$log_dir/$log_file
}

function backup_group_privilleges {
	psql -h $host -p $port -U $user -d $db -f $1 -v sch_name="'$schema'" -t > $2 2>>$log_dir/$log_file
}


function enable_drop {
	sed -i 's/--DROP TABLE/DROP TABLE IF EXISTS/g' $1
}



function create_s3Sql_restore {

	>$log_dir/${clusterID}_${schema}_tables_load.sql
	while read table_name ; do
		if [[ $table_name == $schema* ]]
		then
			table=`echo $table_name | awk -F . '{gsub(/\n$/,"");print $2}'`
			schema=`echo $table_name | awk -F . '{gsub(/\n$/,"");print $1}'`
			echo "COPY $schema.$table FROM 's3://$s3_base/$clusterID/$schema/$table/' credentials 'aws_access_key_id=$aws_key;aws_secret_access_key=$aws_secret' gzip escape acceptinvchars acceptanydate delimiter '|' maxerror 1000 truncatecolumns trimblanks ;" >> $log_dir/${clusterID}_${schema}_tables_load.sql
		fi
	done < $log_dir/${clusterID}_${schema}_tables_list.out

}

function create_new_tables {

	psql -h $host -p $port -U $user -d $db -f $1 -a >>$log_dir/$log_file 2>>$log_dir/$log_file
}

function start_restore_tables {

	psql -h $host -p $port -U $user -d $db -f $1 -a >>$log_dir/$log_file 2>>$log_dir/$log_file

}

function restore_permisiions {

	psql -h $host -p $port -U $user -d $db -f $1 -a >>$log_dir/$log_file 2>>$log_dir/$log_file

}



echo "Starting"

for opt in "$@" ; do
        shift
        case $opt in
                --help)
                        echo "Help initiated"
                        echo $usage

                        exit
                        ;;
                --backup)
                        echo "Backup initiated"
                        log "Started Extracting DDL's"
                        extract_ddl

                        log "Creating SQL File"
                        create_s3Sql

                        log "Uploading to S3"
			upload_s3 $log_dir/${clusterID}_${schema}_tables_unload.sql

                        log "backing up users"
                        backup_users_privilleges ${script_dir}/prv_user_privileges.sql  $log_dir/${clusterID}_${schema}_user_privileges.out

                        log "backing up groups"
                        backup_group_privilleges ${script_dir}/prv_group_privileges.sql  $log_dir/${clusterID}_${schema}_group_privileges.out

                        log "replacing the DDLs"
                        enable_drop $log_dir/${clusterID}_${schema}_tables_ddl.out

                        exit
                        ;;
                --restore)
                        echo "Restore initiated"
                        log "Creating S3 COPY SQL file"

                        create_s3Sql_restore
                        log "Creating Tables in new schema"

                        create_new_tables $log_dir/${clusterID}_${schema}_tables_ddl.out

                        log "Started Load from S3"
                        start_restore_tables $log_dir/${clusterID}_${schema}_tables_load.sql

                        log "Restoring Users"
                        restore_permisiions $log_dir/${clusterID}_${schema}_user_privileges.out

                        log "Restoring Groups"
                        restore_permisiions $log_dir/${clusterID}_${schema}_group_privileges.out
                        log "Restore Complete"

                        exit
                        ;;
                *)
                        echo "Invalid Option $usage" -$OPTARG

                        exit
                        ;;
        esac
done

