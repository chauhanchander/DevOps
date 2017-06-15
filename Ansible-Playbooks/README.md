## aPaaS JBoss

## MVP Goal (aPaaS JBoss 1.0):

##Ranges assigned for Sandbox env:
* VIP (f5 bigIP):     172.16.113.22   -   172.16.113.61   (40 IPs on VLAN 113)
* VMs (VLAN 20):      172.16.20.128   -   172.16.20.207   (80 IPs on VLAN 20)
* NOTE: ALL RANGES HAVE BEEN VERIFIED TO NOT HAVE ANY PTR DNS RECORDS IN DEV DNS, AND NOT PINGABLE AS OF 10/13/2015

## IP ranges for Sandbox Env
```
INC0248074 bp 4/6/2015              172        16           111        100
INC0248074 bp 4/6/2015              172        16           111        101
INC0248074 bp 4/6/2015              172        16           111        102
INC0248074 bp 4/6/2015              172        16           111        103
INC0248074 bp 4/6/2015              172        16           111        104
INC0248074 bp 4/6/2015              172        16           111        105
INC0248074 bp 4/6/2015              172        16           111        106
INC0248074 bp 4/6/2015              172        16           111        107
INC0248074 bp 4/6/2015              172        16           111        108
INC0248074 bp 4/6/2015              172        16           111        109

INC0248074 BP 4/3/2015              172        16           110        44	cvldansible1.cscdev.com.
INC0248074 BP 4/3/2015              172        16           110        45	cscdansbldns.ndcvc.com.
INC0248074 BP 4/3/2015              172        16           110        46
INC0248074 BP 4/3/2015              172        16           110        47	f5 VIP route in place
INC0248074 BP 4/3/2015              172        16           110        48	f5 VIP route in place
INC0248074 BP 4/3/2015              172        16           110        49	f5 VIP route in place
INC0248074 BP 4/3/2015              172        16           110        50
INC0248074 BP 4/3/2015              172        16           110        51
INC0248074 BP 4/3/2015              172        16           110        52
INC0248074 BP 4/3/2015              172        16           110        53
INC0248074 BP 4/3/2015              172        16           110        54
```

# Coding Standards
* Ansible is basically yaml. Emacs, VI, etc. all have yaml modes. They help.
* We indent yaml 2 spaces. No tabs.

# Other Notes

### Working on cluster concept - thinking of a group of machines as a configuration unit
* https://gist.github.com/anonymous/5e1f88c5acc0dc699093
