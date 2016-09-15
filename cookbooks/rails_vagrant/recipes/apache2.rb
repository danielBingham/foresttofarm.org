#
# Cookbook Name:: rails_vagrant
# Recipe:: apache2
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'apache2' do
    action :install
end

# We need to make sure that www-data owns this directory, because
# passenger will need write access to it.
directory '/var/www' do
  owner 'www-data'
  group 'www-data'
  mode  '0755'
  action :create
end

apt_repository 'passenger' do
  uri 'https://oss-binaries.phusionpassenger.com/apt/passenger'
  components ['main']
  distribution 'trusty'
  key '561F9B9CAC40B2F7'
  keyserver 'keyserver.ubuntu.com'
  action :add
  deb_src true
end

package 'libapache2-mod-passenger' do
    action  :install
end

execute 'Enable passenger' do
    command 'a2enmod passenger'
end

execute 'Restart apache2' do
    command 'service apache2 restart'
end
