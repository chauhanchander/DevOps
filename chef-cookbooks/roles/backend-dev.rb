# roles/backend.rb

name "backend-dev"
description "Install solr along with tomcat & mysql"
run_list "recipe[solr::properties_dev]", "recipe[solr::dev-solr]", "recipe[percona::server]"
     default_attributes({
	"company" => "viewlift"
})
     override_attributes({
        "mysql" => { "server_root_password" => "viewlift@1234" }
})
