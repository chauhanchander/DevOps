# environments/qa.rb

name "qa"
description "For qa"
#cookbook_versions({
#  'apache2'=>'~> 3.2.2',
#  'default'=>'~> 0.1.0',
#  'mysql'=>'~> 5.6.0',
#  'nagios3'=>'~> 1.7.1',
#  'tomcat-all'=>'~> 0.2.0'
#})

override_attributes({ 'mysql' => {'mysql-master' => 'mysql-hostmaster.qa.snagfilms.internal',
  'mysql-slave' => 'mysql-hostslave.qa.snagfilms.internal'},
  'solr' => {'solr-master' => 'solr-hostmaster.qa.snagfilms.internal',
  'solr-slave' => 'solr-hostslave.qa.snagfilms.internal'} })
