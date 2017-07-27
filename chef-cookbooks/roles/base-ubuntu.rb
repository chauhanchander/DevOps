# roles/base-ubuntu.rb

name"base-ubuntu"
description "base role for ubuntu"
run_list "recipe[chef-client]","recipe[apt]","recipe[ntp]"



