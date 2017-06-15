# HOW TO USE THIS ROLE:

### This role expects the following variables to be set:
* start_ip	THIS IS THE STARTING RANGE TO FIND A FREE IP
* end_ip		THIS IS THE ENDING RANGE TO FIND A FREE IP
* server_name	THIS IS THE DNS ENTRY NAME TO ADD (both FWD and PTR records)
* dns_environment THIS IS THE ENVIRONMENT TO SET FOR DNS REST CLIENT. dev OR prod typically.
### The output of a successful play is the IP address that got assigned.  It gets stored in the variable: new_host_ip

### To run directly via commandline:
`ansible-playbook -i hosts_emcalvin_dns_example roles/dns-record/tasks/main.yml --extra-vars "start_ip=172.16.107.10 end_ip=172.16.107.250 server_name=cvldarch01-52v.apps.cscdev.com dns_environment=dev"`

### The inventory file in the above example uses the localhost to run the playbook and looks like this:
```
[local]
127.0.0.1
```
