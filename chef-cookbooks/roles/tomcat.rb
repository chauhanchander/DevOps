# roles/tomcat.rb

name "tomcat"
description "tomcat"
run_list "role[default]", "recipe[tomcat8]","recipe[mysql_connector]"
     default_attributes({
	"company" => "viewlift"
})
