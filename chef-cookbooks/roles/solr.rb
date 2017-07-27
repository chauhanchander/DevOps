# roles/mysql.rb

name "solr"
description "Install solr along with tomcat"
run_list "role[default]", "recipe[tomcat-all]", "recipe[tomcat-all::dcvl-tomcat]", "recipe[solr]", "recipe[solr::dcvl-solr]"
     default_attributes({
	"company" => "viewlift"
})
