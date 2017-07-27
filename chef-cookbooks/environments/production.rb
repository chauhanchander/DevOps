# environments/production.rb

name "production"
description "For production"
#cookbook "apache", "=0.1.1" # i intend to use version control. 

override_attributes({ 'mysql' => {'mysql-master' => 'mysql-hostmaster.prod.snagfilms.internal'},
  #'mysql-slave' => 'mysql-hostslave.prod.snagfilms.internal'},
  'solr' => {'solr-master' => 'solr-hostmaster.prod.snagfilms.internal'} })
  #'solr-slave' => 'solr-hostslave.prod.snagfilms.internal'} })
