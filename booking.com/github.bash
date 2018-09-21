#!/usr/bin/env bash

# Environment variables

export SED=`which sed`
export CUT=`which cut` 
export WGET=`which wget`
export CHMOD=`which chmod`
export PWD=`which pwd`
export CURL=`which curl`
export CURRENT_DIR=`${PWD}`
export JQ=`${CURRENT_DIR}/jq`
export BRANCH='master'
export JQDOWNLOAD='https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64'

if [ "$#" -ne 1  ];
    then echo "USAGE : $0 'FILENAME'"
        echo " For Example : -"
        echo "  $0 /home/filename "
        exit 1
fi


export FILENAME="${1}"

if [ i! -e ${JQ}]
then
    ${WGET} -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
    chmod +x ${JQ}
fi

while read -r line 

    COMMIT_SHA=$( ${CURL} -s https://api.github.com/repos/${GITHUB_REPO_NAME}/commits/${MASTER} | ${JQ} '.sha' | ${SED} 's/"//g');
    echo "$COMMIT_SHA";
 
do

done < "$FILENAME" 
