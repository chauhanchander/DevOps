# These modules are written for generic use. Tested on Ansible 2.1.0.
==

## Getting the latest version of Ansible

* yum install python-jinja2 (if not in YUM repo, get it direct from CentOS here: rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/python-jinja2-2.2.1-2.el6_5.x86_64.rpm)
* yum install PyYAML
* git clone git://github.com/ansible/ansible.git --recursive
* source ansible/hacking/env-setup

This will download the latest version from git, and setup your env vars (path, etc..)
---

You can also install the RPM from EPEL but only 1.9 is currently available as of this writing.  
---
### Roles have this type of directory structure:

* roles/$ROLE_NAME/tasks
* roles/$ROLE_NAME/templates
* roles/$ROLE_NAME/defaults
* roles/$ROLE_NAME/handlers
* roles/$ROLE_NAME/files
* roles/$ROLE_NAME/meta

See http://docs.ansible.com/ansible/playbooks_best_practices.html#directory-layout for details

---
### Testing your roles with Vagrant:

This repository has a Vagrantfile and vagrant_playbook on it.  This makes it easy for you to test your newly written roles on a temporary machine using Vagrant (and usually VirtualBox as the underlying hypervisor).  
* To learn more about VirtualBox, see https://www.virtualbox.org
* To learn more about Vagrant, see https://www.vagrantup.com 
---
Vagrant quick HOWTO:
* Install VirtualBox
* Install Vagrant
* git clone this repository
* Edit vagrant_playbook.yml and assign the roles you want to test.
* Run "vagrant up"  (MUST BE IN DIR WHERE Vagrant FILE EXISTS)
* Run "vagrant ssh" to get on the VM and poke around.
* When you are done, run: "vagrant destroy"
* Enjoy!
