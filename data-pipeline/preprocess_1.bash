#!/bin/bash

# Input Params passed via data-pipeline

export DATE_YYYMMDD=$1
export SOURCE_ENTITY_NAME=$2 #Accounts.txt 
export BUCKET_CATEGORY=$3 #Category to distinguish source files , case insensitive input , example veeva, peoplesoft etc
export BUCKET_SUBFOLDER=$4
export BUCKET_NAME=$5 #Top Level Bucket Name - currently not sent as param from pipeline
export FREQUENCY=$6
export ENVIRONMENT=$7
export AWS=`which aws`
#Bucket Folders as created on the aws s3
export VEEVA="Veeva"
export EAL="EAL"
export CAST="CAST"
export PEOPLESOFT="Peoplesoft"
export CONCUR="Concur"

SMALLCASE_CATEGORY=`echo "$BUCKET_CATEGORY" | tr '[:upper:]' '[:lower:]'`;
#echo $DATE_YYYMMDD
#echo "SMALLCASE_CATEGORY = $SMALLCASE_CATEGORY"
#LANDING_FINALDIR=${BUCKET_NAME}/Landing/$1/${CAST}/${SOURCE_ENTITY_NAME}
#echo $LANDING_FINALDIR

case $SMALLCASE_CATEGORY in
"veeva") aws s3 mv s3://$BUCKET_NAME/$ENVIRONMENT/Inbound/Landing/$FREQUENCY/$1/$VEEVA s3://$BUCKET_NAME/$VEEVA/Processing --recursive --exclude "*" --include "*$BUCKET_SUBFOLDER*";;

##aws s3 mv s3://gsk-dev-dp-logs/Landing/20170131/veeva s3://gsk-dev-dp-logs/veeva/Processing --recursive --exclude "*" --include "*Account*"
##move: s3://gsk-dev-dp-logs/Landing/20170131/veeva/Accounts/Accounts.txt to s3://gsk-dev-dp-logs/veeva/Processing/Accounts/Accounts.txt

"cast") aws s3 cp s3://${BUCKET_NAME}/$ENVIRONMENT/Inbound/Landing/$FREQUENCY/$1/${CAST}/${SOURCE_ENTITY_NAME}  s3://${BUCKET_NAME}/${CAST}/Processing/${SOURCE_ENTITY_NAME};;
"peoplesoft")  aws s3 cp s3://$BUCKET_NAME/$ENVIRONMENT/Inbound/Landing/$FREQUENCY/$1/$PEOPLESOFT/$SOURCE_ENTITY_NAME  s3://$BUCKET_NAME/$PEOPLESOFT/Processing/$SOURCE_ENTITY_NAME;;
"eal")         aws s3 cp s3://$BUCKET_NAME/$ENVIRONMENT/Inbound/Landing/$FREQUENCY/$1/$EAL/$SOURCE_ENTITY_NAME  s3://$BUCKET_NAME/$EAL/Processing/$SOURCE_ENTITY_NAME;;
"concur")      aws s3 cp s3://$BUCKET_NAME/$ENVIRONMENT/Inbound/Landing/$FREQUENCY/$1/$CONCUR/$SOURCE_ENTITY_NAME  s3://$BUCKET_NAME/$CONCUR/Processing/$SOURCE_ENTITY_NAME;;
*)       echo "Sorry, Incorrect Category provided in the parameters!";exit 1;

esac
