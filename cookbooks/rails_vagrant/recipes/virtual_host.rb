#
# Cookbook Name:: rails_vagrant
# Recipe:: virtual_host
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Append the vagrant user to the www-data group. This will allow us to modify
# the source directory when we're sshed into the vagrant.   
group 'www-data' do
    action :modify
    members 'vagrant'
    append  true
end

virtual_host_path = File.join('/etc/apache2/sites-available/', node['rails_vagrant']['server_name'])
virtual_host_path << '.conf'
template virtual_host_path do
    source  'virtual_host.conf.erb'
    owner   'root'
    group   'root'
    mode    '0755'
    variables({
        :server_name => node['rails_vagrant']['server_name'],
        :server_alias => node['rails_vagrant']['server_alias'],
        :webmaster_email => node['rails_vagrant']['webmaster_email'],
        :document_root => node['rails_vagrant']['document_root']
    })
end

execute 'Disable default site' do
    command 'a2dissite 000-default'
end

execute 'Enable learnrails.local' do
    command 'a2ensite learnrails.local'
end

execute 'Restart apache2' do
    command 'service apache2 restart'
end
