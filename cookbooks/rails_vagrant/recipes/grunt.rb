#
# Cookbook Name:: rails_vagrant
# Recipe:: grunt
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Append the vagrant user to the www-data group.  We need to do this
# because grunt needs write acccess to the source_directory.
group 'www-data' do
    action :modify
    members 'vagrant'
    append  true
end

# Install grunt client
nodejs_npm "grunt-cli"

# We need to run npm install in order to install all of grunt's dependencies.
# Should pick up in project.json with out any help.
execute "Run 'npm install' in the project directory" do
    cwd node['rails_vagrant']['source_directory']
    command "npm install"
end

