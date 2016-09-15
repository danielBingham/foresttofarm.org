#
# Cookbook Name:: rails_vagrant
# Recipe:: configuration
#
# Configure rails database by generating the database config file from a
# template.
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


database_file = File.join(node['rails_vagrant']['config_directory'], 'database.yml')
template database_file do
   source  'config/database.yml.erb'
   owner   'www-data'
   group   'www-data'
   mode     '0644'
   variables(
       :host    =>  node['rails_vagrant']['database']['host'],
       :development_name    =>  node['rails_vagrant']['database']['development']['name'],
       :development_username => node['rails_vagrant']['database']['development']['username'],
       :development_password => node['rails_vagrant']['database']['development']['password'],
       :test_name => node['rails_vagrant']['database']['test']['name'],
       :test_username => node['rails_vagrant']['database']['test']['username'],
       :test_password => node['rails_vagrant']['database']['test']['password']
   )
end

