# roles/percona.rb

name "percona"
description "percona"
run_list "role[default]"
#, "recipe[percona::server]", "recipe[percona::custom]"
     default_attributes({
	"company" => "viewlift"
})
