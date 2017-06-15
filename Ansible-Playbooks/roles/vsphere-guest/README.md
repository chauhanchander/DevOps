# HOW TO USE THIS ROLE:

### This role requires Ansible 1.9+ !!! ###
### This role requires the custom Cablevision written Ansible dependency vSphere_linux_guest_config_nic ###

### This role expects the following variables to be set:
vm_name=emcalvin_via_ansible_5 ip_addr=172.16.110.44 ip_mask=255.255.255.0 ip_gateway=172.16.110.1 fqdn=emcalvin-ansible-test.cscdev.com vm_memsize=6144 vm_numcpus=1
* vm_name       What you want to call the new virtual machine in vSphere. Usually this is the short hostname.
* ip_addr       The IP address for the new VM
* ip_mask       The Netmask for the new VM
* ip_gateway    The IP gateway for the new VM
* fqdn          The FQDN hostname for the new VM.  This gets set in the OS level on the VM.
* vm_memsize	The amount of memory in MB to allocate to the VM.
* vm_numcpus	The number of CPUs to allocate to the VM.
### The output of a successful play is the VM being created in vSphere and the NIC on that VM being configured and activated.

### To run directly via commandline:
`ansible-playbook -i hosts_emcalvin_vSphere_example roles/vsphere-guest/tasks/main.yml --extra-vars "vm_name=wwwapps1 ip_addr=172.16.110.44 ip_mask=255.255.255.0 ip_gateway=172.16.110.1 fqdn=wwwapps1.cscdev.com vm_memsize=6144 vm_numcpus=1"`

OR in a larger playbook:
`ansible-playbook -i hosts_emcalvin_vSphere_example vSphere_sample.yml --extra-vars "vm_name=wwwapps1 ip_addr=172.16.110.44 ip_mask=255.255.255.0 ip_gateway=172.16.110.1 fqdn=wwwapps1.cscdev.com vm_memsize=6144 vm_numcpus=1"`

### The inventory file in the above example uses the localhost to run the playbook and looks like this:
```
[local]
127.0.0.1
```

### Things you need to look at before running this:
*Look in roles/vsphere-guest/files/settings.ini to set the connection details to vSphere
*Look in roles/vsphere-guest/files/requirements.txt for the list of python modules you need to install via pip
