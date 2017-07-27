# roles/mysql.rb

name "mysql"
description "mysql"
run_list "role[default]", "recipe[mysql::server]", "recipe[mysql::custom]"
     default_attributes({
	"company" => "viewlift"
})
     override_attributes({
	"mysql" => { "server_root_password" => "viewlift@1234" }
})
