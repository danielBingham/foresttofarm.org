#
# Cookbook Name:: rails_vagrant
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# Install and configure the MySQL client.
mysql_client 'default' do
    action :create
end

# Install and configure the MySQL service.
mysql_service 'default' do
    initial_root_password node['rails_vagrant']['database']['root_password']
    action [:create,:start]
end

# Install the mysql2_chef_gem which is required by the mysql_database cookbook.
mysql2_chef_gem 'default' do
    action :install
end

# Let's hang on to the connection info so we don't have to repeat it.  It's
# pretty verbose.
connection_info = {
    :host => node['rails_vagrant']['database']['host'],
    :username => 'root',
    :password => node['rails_vagrant']['database']['root_password']
}

# create the development database instance
mysql_database node['rails_vagrant']['database']['development']['name'] do
    connection connection_info
    action :create
end

# Add a development database user
mysql_database_user node['rails_vagrant']['database']['development']['username'] do
    connection connection_info
    password node['rails_vagrant']['database']['development']['password']
    database_name node['rails_vagrant']['database']['development']['name']
    host node['rails_vagrant']['database']['host']
    action [:create,:grant]
end

# create the test database instance
mysql_database node['rails_vagrant']['database']['test']['name'] do
    connection connection_info
    action :create
end

# Add a test database user
mysql_database_user node['rails_vagrant']['database']['test']['username'] do
    connection connection_info
    password node['rails_vagrant']['database']['test']['password']
    database_name node['rails_vagrant']['database']['test']['name']
    host node['rails_vagrant']['database']['host']
    action [:create,:grant]
end
