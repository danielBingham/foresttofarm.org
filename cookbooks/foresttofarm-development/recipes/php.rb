#
# Cookbook Name:: development
# Recipe:: php
#
# Copyright (c) 2016 The Authors, All Rights Reserved.



# There's a bug in the PHP Cookbook that makes it impossible to
# edit apache2's PHP configuration file through that cookbook.  So
# to work around this, we're going to use Chef's FileEdit object in
# a Ruby Block.
#
# Bug reference: https://github.com/chef-cookbooks/php/issues/116 
ruby_block 'Update the PHP Apache2 Configuration' do
    block do
        php_ini_handle = Chef::Util::FileEdit.new(node['foresttofarm.org']['php']['config_file_path'])
        php_ini_handle.search_file_replace_line(/display_errors = Off/, 'display_errors = On');
        php_ini_handle.search_file_replace_line(/display_startup_errors = Off/, 'display_startup_errors = On');
        php_ini_handle.search_file_replace_line(/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/, 'error_reporting = E_ALL');
        php_ini_handle.write_file
    end
end

# This is something that really ought to have been handled by the
# php5-mcrypt cookbook, but wasn't.  So... we're doing it here!
execute "Enable mcrypt mod" do
    command "php5enmod mcrypt"
end

database_file = File.join(node['foresttofarm.org']['config_directory'], 'database.php')
template database_file do
   source  'config/database.php.erb'
   owner   'www-data'
   group   'www-data'
   mode     '0755'
   variables(
       :host    =>  node['foresttofarm.org']['database']['host'],
       :name    =>  node['foresttofarm.org']['database']['name'],
       :username => node['foresttofarm.org']['database']['username'],
       :password => node['foresttofarm.org']['database']['password']
   )
end

app_file = File.join(node['foresttofarm.org']['config_directory'], 'app.php')
template app_file do
    source  'config/app.php.erb'
    owner   'www-data'
    group   'www-data'
    mode    '0755'
    variables(
        :url    =>  node['foresttofarm.org']['server_name'],
        :secret_key =>  node['foresttofarm.org']['secret_key']
    )
end

config_files = ['auth.php', 'cache.php',  'mail.php', 'session.php', 'view.php']
config_files.each do |config_file|
    file = File.join(node['foresttofarm.org']['config_directory'], config_file );
    source_template = File.join('config', config_file);
    source_template << '.erb'
    template file do
        source  source_template
        owner   'www-data'
        group   'www-data'
        mode    '0755'
    end
end

testing_environment_path = File.join(node['foresttofarm.org']['config_directory'], 'testing')
directory testing_environment_path do
    owner   'www-data'
    group   'www-data'
    recursive   true
end

config_files = ['testing/session.php', 'testing/cache.php']
config_files.each do |config_file|
    file = File.join(node['foresttofarm.org']['config_directory'], config_file );
    source_template = File.join('config', config_file);
    source_template << '.erb'
    template file do
        source  source_template
        owner   'www-data'
        group   'www-data'
        mode    '0755'
    end
end

composer_project node['foresttofarm.org']['source_directory'] do
    quiet   false
    action  :dump_autoload
end

composer_project node['foresttofarm.org']['source_directory'] do
    dev     true
    quiet   false
    action  :install
end
