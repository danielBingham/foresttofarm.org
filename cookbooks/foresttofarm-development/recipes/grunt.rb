#
# Cookbook Name:: foresttofarm-development
# Recipe:: grunt
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install grunt client
nodejs_npm "grunt-cli"

apt_package "phantomjs"

# We need to run npm install in order to install all of grunt's dependencies.
# Should pick up in project.json with out any help.
execute "Run 'npm install' in the project directory" do
    cwd node['foresttofarm.org']['source_directory']
    command "npm install"
end

# Append the vagrant user to the www-data group.  We need to do this
# because grunt needs write acccess to the source_directory.
group 'www-data' do
    action :modify
    members 'vagrant'
    append  true
end
