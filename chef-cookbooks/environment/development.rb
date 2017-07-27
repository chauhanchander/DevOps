# environments/development.rb

name "development"
description "For development"
cookbook_versions({
  'apache2'=>'~> 3.2.2',
  'default'=>'~> 0.1.0',
  'mysql'=>'~> 5.6.0',
  'nagios3'=>'~> 1.7.1',
  'tomcat-all'=>'~> 0.2.0'
})

override_attributes({ 'mysql' => {'mysql-master' => 'mysql-hostmaster.dev.snagfilms.internal',
  'mysql-slave' => 'mysql-hostslave.dev.snagfilms.internal'},
  'solr' => {'solr-master' => 'solr-hostmaster.dev.snagfilms.internal', 
  'solr-slave' => 'solr-hostslave.dev.snagfilms.internal'} })
