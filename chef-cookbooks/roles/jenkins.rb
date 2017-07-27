# roles/jenkins.rb


name "jenkins"
description "jenkins"
run_list "role[default]", "recipe[jenkins_server]","recipe[tomcat]"
     default_attributes({
	"company" => "viewlift"
})
