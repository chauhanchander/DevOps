# roles/frontend.rb

name "frontend-New-Farm"
description "Install and configure apache server along with tomcat application"
run_list "role[default]", "recipe[openjava]", "recipe[tomcat-all]", "recipe[tomcat-all::nextgen-tomcat]", "recipe[mysql_connector]", "recipe[Deploy_WAR::newfarm]", "recipe[apache2]", "recipe[apache2::nextgen-web]", "recipe[dims]", "recipe[ldap]"

#run_list "recipe[apache2]", "recipe[apache2::nextgen-web]"
     default_attributes({
	"company" => "viewlift"
})
