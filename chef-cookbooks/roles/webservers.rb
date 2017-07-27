# roles/webserver.rb
 
name "webserver"
description "Install and configure apache server"
run_list "role[default]", "recipe[apache2]", "recipe[apache2::dcvl-web]"
     default_attributes({
	"company" => "viewlift",
})
