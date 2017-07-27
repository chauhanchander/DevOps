#!/bin/bash

## Input Params passed via data-pipeline

TENANT_ID=$1 ##1
TARGET_NAME=$2 ##ods
SOURCE_NAME=$3 ##s3
SOURCE_ENTITY_NAME=$4 ##Accounts.txt
TARGET_ENTITY_NAME=$5 ##d_account
TOTAL_EXECUTOR_CORES=$6 ##8
EXECUTOR_MEMORY=$7 ##16G
DRIVER_MEMORY=$8
BUCKET_NAME=$9
EXECUTOR_CORES=${10}
CONSISTENCY_LEVEL=${11}
CASSANDRA_HOST="172.23.19.12"
OPTIONAL=${12}


## The below added on feb 15 to address the retry on activity level
if [ ! -f /home/ec2-user/dp-assembly-0.0.1-RC1.jar ]; then
aws s3 cp s3://gsk-dev-dp-jars/dataProcessor-assembly-0.0.1-RC1.jar /home/ec2-user/dp-assembly-0.0.1-RC1.jar
fi
if [ ! -f /home/ec2-user/job.conf ]; then
aws s3 cp s3://gsk-dev-dp-conf/job.conf /home/ec2-user/job.conf
fi

## Job Load Processing through dse spark-submit command

dse spark-submit --class com.inventivhealth.etl.ETL --total-executor-cores $TOTAL_EXECUTOR_CORES --executor-cores $EXECUTOR_CORES --executor-memory $EXECUTOR_MEMORY --driver-memory $DRIVER_MEMORY --conf "spark.executor.extraJavaOptions=-XX:ThreadStackSize=81920" --conf spark.cassandra.output.consistency.level=$CONSISTENCY_LEVEL --conf spark.cassandra.output.batch.size.bytes=1024 --conf spark.cassandra.output.concurrent.writes=32 --conf spark.cassandra.output.batch.grouping.key=none  /home/ec2-user/dp-assembly-0.0.1-RC1.jar --config-file /home/ec2-user/job.conf --tenant-id $TENANT_ID --source-name $SOURCE_NAME --source-entity-name $SOURCE_ENTITY_NAME --target-name $TARGET_NAME --target-entity-name $TARGET_ENTITY_NAME 


if [ $? -eq 0 ] 
then

last_run=`cqlsh $CASSANDRA_HOST -e "select toUnixTimestamp(last_run) AS l from $TARGET_NAME.etl_config where target_name='$TARGET_NAME' and tenant_id=$TENANT_ID and source_name='$SOURCE_NAME' and source_entity_name='$SOURCE_ENTITY_NAME' and target_entity_name='$TARGET_ENTITY_NAME' limit 1"`

##extracting only the number from query result
 FINALNUMBER=`echo "$last_run"|sed 's/(.*//' | grep -o '[0-9]*'`
 echo "FINALNUMBER ${FINALNUMBER}"

if [ ! "$FINALNUMBER" ]; then
   echo "last_run returned empty verify if spark job populated the config table for last_run"
   echo "Please Do not run the pipeline to load the data again"

   # The below was added to Feb 19 to take care of the situation where the etl_config is not populated with the last_run

   last_run=`cqlsh $CASSANDRA_HOST -e "select toUnixTimestamp(now()) AS l from $TARGET_NAME.etl_config where target_name='$TARGET_NAME' and tenant_id=$TENANT_ID and source_name='$SOURCE_NAME' and source_entity_name='$SOURCE_ENTITY_NAME' and target_entity_name='$TARGET_ENTITY_NAME' limit 1"`
  FINALNUMBER=`echo "$last_run"|sed 's/(.*//' | grep -o '[0-9]*'`
  echo "Setting FINALNUMBER to current time stamp  ${FINALNUMBER}"
  # exit 1
fi 

## Processed Folder Creation

 prev_entity_loc=`cqlsh $CASSANDRA_HOST -e "select prev_entity_loc AS l from $TARGET_NAME.etl_config where target_name='$TARGET_NAME' and tenant_id=$TENANT_ID and source_name='$SOURCE_NAME' and source_entity_name='$SOURCE_ENTITY_NAME' and target_entity_name='$TARGET_ENTITY_NAME' limit 1"`

# Processing Folder
 
 current_entity_loc=`cqlsh $CASSANDRA_HOST -e "select current_entity_loc AS l from $TARGET_NAME.etl_config where target_name='$TARGET_NAME' and tenant_id=$TENANT_ID and source_name='$SOURCE_NAME' and source_entity_name='$SOURCE_ENTITY_NAME' and target_entity_name='$TARGET_ENTITY_NAME' limit 1"`

 ##Processing directory input preparation
 PROCESSING_DIR=`echo $current_entity_loc|sed 's/(.*//'|sed 's/.*- //'|sed 's/\/{.*//'|sed 's/ //'` #gsk-dp-dev-logs/EAL/Processing
 PROCESSING_FINALDIR="${PROCESSING_DIR}/${SOURCE_ENTITY_NAME}"   				    #gsk-dp-dev/logs/EAL/Processing/Accounts.txt or Account(folder)
 echo "Processing_finaldir $PROCESSING_FINALDIR"
 ##Processed Directory Ouput preparation
 PROCESSED_DIR=`echo $prev_entity_loc|sed 's/(.*//'|sed 's/.*- //'|sed 's/\/{.*//'|sed 's/.* //'`    #gsk-dp-dev-logs/EAL/Processed

 PROCESSED_FINALDIR="${PROCESSED_DIR}/${FINALNUMBER}/${SOURCE_ENTITY_NAME}" 				    #gsk-dp-dev-logs/EAL/Processed/124343434347/Accounts.txt

 echo "Processed_finaldir $PROCESSED_FINALDIR"
 ## Finally Copying the content from the Processing to Processed

 if [[ $SOURCE_ENTITY_NAME == *[.]* ]]  #checks if its a folder or a file , folders are used for veeva 
 then 
      
      # if the input is a file
#  
#      aws s3 cp s3://${PROCESSING_FINALDIR} s3://${PROCESSING_DIR}/Archive/ # copy it to archive before you move, ensure theres Archive folder under Processing

       aws s3 cp s3://${PROCESSING_FINALDIR} s3://${PROCESSED_FINALDIR}  # It will create the directory of $FINALNUMBER under the Processed folder and moves the files.

 else
      # if the input is a folder

      aws s3 cp s3://${PROCESSING_DIR} s3://${PROCESSED_DIR}/$FINALNUMBER --recursive --exclude "*" --include "*${SOURCE_ENTITY_NAME}*"

   #   aws s3 mv s3://${PROCESSING_DIR} s3://${PROCESSING_DIR}/Archive/ --recursive --exclude "*" --include "*${SOURCE_ENTITY_NAME}*" # moving it to archive 

 fi

 # check if last aws cli command failed 

    if [ "$?" -ne "0" ]; then
        echo "Error while preparing processed folder"
        exit 1
    fi

else 
      if [ "$OPTIONAL" ]; then
		  echo "OPTIONAL Argument present"
          exit 0
      fi 
	  
 exit 1

fi