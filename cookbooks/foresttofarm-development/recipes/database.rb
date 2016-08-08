#
# Cookbook Name:: development
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# Install and configure the MySQL client.
mysql_client 'default' do
    action :create
end

# Install and configure the MySQL service.
mysql_service 'default' do
    initial_root_password node['foresttofarm.org']['database']['root_password']
    action [:create,:start]
end

# Install the mysql2_chef_gem which is required by the mysql_database cookbook.
mysql2_chef_gem 'default' do
    action :install
end

# Let's hang on to the connection info so we don't have to repeat it.  It's
# pretty verbose.
connection_info = {
    :host => node['foresttofarm.org']['database']['host'],
    :username => 'root',
    :password => node['foresttofarm.org']['database']['root_password']
}

# create the database instance
mysql_database node['foresttofarm.org']['database']['name'] do
    connection connection_info
    action :create
end

# Add a database user
mysql_database_user node['foresttofarm.org']['database']['username'] do
    connection connection_info
    password node['foresttofarm.org']['database']['password']
    database_name node['foresttofarm.org']['database']['name']
    host node['foresttofarm.org']['database']['host']
    action [:create,:grant]
end

# Import the database's schema file from the data directory

schema_path = File.join(node['foresttofarm.org']['database']['data_directory'], node['foresttofarm.org']['database']['schema_file'])

# Cache some of the attributes we need to keep this marginally readable.
host = node['foresttofarm.org']['database']['host']
username = node['foresttofarm.org']['database']['username']
password = node['foresttofarm.org']['database']['password']
database_name = node['foresttofarm.org']['database']['name']

execute "Import database schema" do
  command "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} < #{schema_path}"
  not_if  "mysql -h #{host} -u #{username} -p#{password} -D #{database_name} -e 'describe plants;'"
end

# Import the data into the newly created database from the csv file.
data_file_path = File.join(node['foresttofarm.org']['database']['data_directory'], node['foresttofarm.org']['database']['data_file'])
execute "Import data into schema" do
    cwd node['foresttofarm.org']['source_directory']
    command "php artisan data:load #{data_file_path}"
end
