#
# Cookbook Name:: rails_vagrant
# Recipe:: grunt
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install grunt client
nodejs_npm "grunt-cli"

# We need to run npm install in order to install all of grunt's dependencies.
# Should pick up in project.json with out any help.
execute "Run 'npm install' in the project directory" do
    cwd node['rails_vagrant']['source_directory']
    command "npm install"
end

