#!/bin/bash

#Ensure user passed in the input file and the file exists
if [ ! -f "$1" ]
then
  echo "Usage: $0 input_filename ANYTHING_ELSE_TO_PASS_TO_ANSIBLE-PLAYBOOK"
  echo "Example: $0 input_filename --skip-tags=delete_vm"
  echo "Example: $0 input_filename --tags=delete_dns"
  exit 1
fi

INPUT_FILE=$1
shift

#Input file is in YAML format.  Get the common_name from it. We will use that as the output log dirname.
SERVER1_HOSTNAME=`grep ^vm_name: $INPUT_FILE|awk '{print $2}'`

#Create a unique host file for each ansible run
DATETIME=`date +%m-%d-%Y_%H:%M:%S`
OUTPUT_DIR=delete_vm_output/${SERVER1_HOSTNAME}_${DATETIME}/

#Create the output dir
mkdir -p ${OUTPUT_DIR}/

#Copy the input file and playbook to the output dir (for archiving purposes)
cp ${INPUT_FILE} ${OUTPUT_DIR}/
cp delete_vm.yml ${OUTPUT_DIR}/

#Run the ansible playbook
ansible-playbook delete_vm.yml --vault-password-file ~/.delete_vm_vault_pass.txt --extra-vars "@${INPUT_FILE}" $* |tee ${OUTPUT_DIR}/playbook.out
