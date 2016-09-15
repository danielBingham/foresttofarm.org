#
# Cookbook Name:: rails_vagrant
# Recipe:: ruby
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

%w(build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev libsqlite3-dev sqlite3).each do |pkg|
    package pkg do
        action :install
    end
end

unless File.exist?('/usr/local/bin/ruby') 
    directory '/tmp/ruby' do
        owner   'root'
        group   'root'
        mode    '0755'
        action  :create
    end

    remote_file '/tmp/ruby/stable-snapshot.tar.gz' do
        source  'https://cache.ruby-lang.org/pub/ruby/stable-snapshot.tar.gz'
        owner   'root'
        group   'root'
        mode    '0755'
        action  :create
    end

    execute 'Extra ruby source archive' do
        command 'tar -xvzf  stable-snapshot.tar.gz'
        cwd '/tmp/ruby'
    end

    execute 'Configure ruby' do
        command './configure'
        cwd '/tmp/ruby/stable-snapshot'
    end

    execute 'Make ruby' do
        command 'make'
        cwd '/tmp/ruby/stable-snapshot'
    end

    execute 'Install ruby' do
        command 'make install'
        cwd '/tmp/ruby/stable-snapshot'
    end

    directory '/tmp/ruby' do
        recursive   true
        action  :delete
    end
end
