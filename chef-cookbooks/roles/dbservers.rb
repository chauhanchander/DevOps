# roles/webserver.rb

name "dbserver"
description "dbservers"
run_list "recipe[base-ubuntu]", "recipe[mysql]"
     default_attributes({
	"company" => "viewlift"
})
