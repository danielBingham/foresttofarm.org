#
# Cookbook Name:: development
# Recipe:: web
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

    
# Create the virtual host configuration file.
web_app node['foresttofarm.org']['site_name'] do
    server_name node['foresttofarm.org']['server_name']
    server_aliases [node['fqdn']] + node['foresttofarm.org']['server_aliases']
    docroot node['foresttofarm.org']['document_root'] 
    cookbook 'apache2' 
end
