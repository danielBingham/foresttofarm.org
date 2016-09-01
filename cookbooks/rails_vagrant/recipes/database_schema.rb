#
# Cookbook Name:: rails_vagrant
# Recipe:: database_schema
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


schema_path = File.join(node['rails_vagrant']['database']['data_directory'], node['rails_vagrant']['database']['schema_file'])

# Cache some of the attributes we need to keep this marginally readable.
host = node['rails_vagrant']['database']['host']
username = node['rails_vagrant']['database']['username']
password = node['rails_vagrant']['database']['password']
database_name = node['rails_vagrant']['database']['name']
test_table = node['rails_vagrant']['database']['test_table']

execute "Import database schema" do
  command "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} < #{schema_path}"
  not_if  "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} -e 'describe #{test_table};'"
end
