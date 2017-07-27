# roles/default.rb

name "default-dev"
description "default"
run_list "recipe[default]", "recipe[chef-client::init_service]", "recipe[chef-client::cron]" # "role[nagios-client]", "recipe[cloudwatch-monitoring]"#, "recipe[monit]"
#run_list "recipe[default]", "role[nagios-client]"
     default_attributes({
	"company" => "viewlift",
	"aws" => { "key_id" => "AKIAIMOZTHUN4RNSGEUA" },
	"aws_access" => { "secret_key" => "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" }
})
