#/roles/hostnames.rb

name 'hostnames'
description 'hostnmaes setup'
run_list(
  'recipe[hostnames::default]'
)
default_attributes(
  set_fqdn: '*.viewlift.com',
  hostname_cookbook: {
    use_node_ip: true
  }
)
