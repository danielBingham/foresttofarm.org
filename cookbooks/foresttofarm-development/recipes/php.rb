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

composer_project node['foresttofarm.org']['source_directory'] do
    quiet   false
    action  :dump_autoload
end

composer_project node['foresttofarm.org']['source_directory'] do
    dev     true
    quiet   false
    action  :install
end
