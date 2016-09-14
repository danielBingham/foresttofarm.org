#
# Cookbook Name:: rails_vagrant
# Recipe:: database_schema
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


schema_path = File.join(node['rails_vagrant']['database']['data_directory'], node['rails_vagrant']['database']['schema_file'])

# Cache some of the attributes we need to keep this marginally readable.
host = node['rails_vagrant']['database']['host']
username = node['rails_vagrant']['database']['development']['username']
password = node['rails_vagrant']['database']['development']['password']
database_name = node['rails_vagrant']['database']['development']['name']
test_table = node['rails_vagrant']['database']['test_table']

execute "Import development database schema" do
  command "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} < #{schema_path}"
  not_if  "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} -e 'describe #{test_table};'"
end


username = node['rails_vagrant']['database']['test']['username']
password = node['rails_vagrant']['database']['test']['password']
database_name = node['rails_vagrant']['database']['test']['name']

execute "Import test database schema" do
  command "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} < #{schema_path}"
  not_if  "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} -e 'describe #{test_table};'"
end

data_file = File.join(node['rails_vagrant']['database']['data_directory'], node['rails_vagrant']['database']['data_file'])
execute "Load data into development database" do
  command "rake 'load_data_from_csv[#{data_file}]'"
  cwd node['rails_vagrant']['source_directory'] 
end
