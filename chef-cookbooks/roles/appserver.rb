# roles/appserver.rb

name "appserver"
description "appserver"
run_list "role[default]", "recipe[tomcat-all]", "recipe[tomcat-all::dcvl-tomcat]", "recipe[Deploy_WAR]", "recipe[mysql_connector]"
     default_attributes({
	"company" => "viewlift"
})
