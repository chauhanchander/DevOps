#!/bin/bash
count=0
printf "%-5s \t%-20s \t%-20s \t%-30s \t%-10s \t%-10s \t%-10s \t%-30s \e\n" ENV_NO SERVER1_HOSTNAME SERVER2_HOSTNAME COMMON_NAME REQUEST_NUMBER APP_NAME APP_ACCT_NAME APP_ACCT_HOME
for i in `ls jboss*input*.yml`
do
  count=`expr $count + 1`
  printf "%-5s \t" $count
  #echo "Environmen: $count"
  #echo ""
  cat $i | while read key value; do
        if test "$key" = 'server1_hostname:'; then
                #echo $value
                printf "%-20s \t" $value
        fi
        if test "$key" = 'server2_hostname:'; then
                #echo $value
                printf "%-20s \t" $value
        fi
        if test "$key" = 'common_name:'; then
                #echo $value
                printf "%-30s \t" $value
        fi
        if test "$key" = 'request_number:'; then
                #echo $value
                printf "%-10s \t" $value
        fi
        if test "$key" = 'app_name:'; then
                #echo $value
                printf "%-10s \t" $value
        fi
        if test "$key" = 'app_acct_name:'; then
                #echo $value
                printf "%-10s \t" $value
        fi
        if test "$key" = 'app_acct_home:'; then
                #echo $value
                printf "%-30s \n" $value
        fi
  done
  #echo ""
  #echo ""
done
