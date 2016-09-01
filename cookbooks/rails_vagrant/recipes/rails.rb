#
# Cookbook Name:: rails_vagrant
# Recipe:: rails
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


execute 'Install rails' do
    command 'gem install --no-rdoc --no-ri rails'
end

execute 'Run bunder' do
    command 'bundler install'
    cwd node['rails_vagrant']['source_directory']
end
