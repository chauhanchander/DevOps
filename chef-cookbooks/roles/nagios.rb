# roles/webserver.rb

# this file was created by alex kushnir. 

name "nagios"
description "nagios server"
run_list "recipe[nagios::server]" # "recipe[nagios3::nagios_check]"
     default_attributes({
	"company" => "viewlift"
})
