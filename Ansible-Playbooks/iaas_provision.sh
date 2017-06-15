#!/bin/bash

#Ensure user passed in the input file and the file exists
if [ ! -f "$1" ]
then
  echo "Usage: $0 input_filename ANYTHING_ELSE_TO_PASS_TO_ANSIBLE-PLAYBOOK"
  echo "Example: $0 input_filename --skip-tags=create_vip"
  echo "Example: $0 input_filename --tags=create_vm1"
  exit 1
fi

INPUT_FILE=$1
shift

#Input file is in YAML format.  Get the common_name from it. We will use that as the output log dirname.
SERVER1_HOSTNAME=`grep ^server1_hostname: $INPUT_FILE|awk '{print $2}'`

#Create a unique host file for each ansible run
DATETIME=`date +%m-%d-%Y_%H:%M:%S`
OUTPUT_DIR=iaas_provision_output/${SERVER1_HOSTNAME}_${DATETIME}
HOSTFILE=${OUTPUT_DIR}/hostfile

#Create the output dir
mkdir -p ${OUTPUT_DIR}/

#Copy the input file and playbook to the output dir (for archiving purposes)
cp ${INPUT_FILE} ${OUTPUT_DIR}/
cp iaas_provision.yml ${OUTPUT_DIR}/

#create the temporary Ansible Inventory File
echo "[newservers]" > $HOSTFILE
echo ${SERVER1_HOSTNAME} >> $HOSTFILE

#Run the ansible playbook
ansible-playbook -i ${HOSTFILE} iaas_provision.yml --vault-password-file ~/.iaas_vault_pass.txt --extra-vars "@${INPUT_FILE}" $* |tee ${OUTPUT_DIR}/playbook.out
