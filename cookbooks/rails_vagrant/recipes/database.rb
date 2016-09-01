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

# create the database instance
mysql_database node['rails_vagrant']['database']['name'] do
    connection connection_info
    action :create
end

# Add a database user
mysql_database_user node['rails_vagrant']['database']['username'] do
    connection connection_info
    password node['rails_vagrant']['database']['password']
    database_name node['rails_vagrant']['database']['name']
    host node['rails_vagrant']['database']['host']
    action [:create,:grant]
end

