#
# Cookbook Name:: rails_vagrant
# Recipe:: database_schema
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

execute "Setup the database" do
  command "rake db:setup"
  cwd node['rails_vagrant']['source_directory']
end

data_file = File.join(node['rails_vagrant']['database']['data_directory'], node['rails_vagrant']['database']['data_file'])
execute "Load data into development database" do
  command "rake 'db:load_data_from_csv[#{data_file}]'"
  cwd node['rails_vagrant']['source_directory'] 
end
