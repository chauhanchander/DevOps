# roles/frontend.rb

name "frontend-dev"
description "Install and configure apache server along with tomcat application"
run_list "role[default-dev]", "recipe[openjava]", "recipe[tomcat-all]", "recipe[tomcat-all::dev-tomcat]", "recipe[mysql_connector]", "recipe[Deploy_WAR]", "recipe[apache2]", "recipe[apache2::dev-web]", "recipe[dims::dev]"
#run_list "role[default]", "recipe[openjava]", "recipe[tomcat-all]", "recipe[tomcat-all::nextgen-tomcat]", "recipe[mysql_connector]", "recipe[apache2]", "recipe[apache2::nextgen-web]", "recipe[dims]", "recipe[elk::client]", "recipe[ldap]"
#run_list "role[default]", "recipe[openjava]",  "recipe[apache2]", "recipe[apache2::nextgen-web]", "recipe[dims]", "recipe[elk::client]"
     default_attributes({
	"company" => "viewlift"
})
