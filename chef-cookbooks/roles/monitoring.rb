# roles/monitoring.rb

name 'monitoring'
description 'Monitoring server'

run_list(
  'recipe[default]',
  'recipe[chef-client::cron]',
  'recipe[nagios::server]', 
  'recipe[nagios::client]',
  'recipe[postfix]'
)

default_attributes(
  :nagios => {
    :server_auth_method => 'htauth',
    :url => 'http://nagios.viewlift.com',
    :notifications_enabled => '0'
  }
)

override_attributes(
  :postfix => {
    :myhostname => 'nagios.viewlift.com',
    :mydomain => 'viewlift.com'
  }
)
