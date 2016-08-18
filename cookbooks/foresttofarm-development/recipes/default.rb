#
# Cookbook Name:: foresttofarm-development
# Recipe:: default
#
# Copyright (c) 2016 Daniel Bingham, All Rights Reserved.

include_recipe  'apt::default'
include_recipe  'apache2::default'
include_recipe  'php::default'
include_recipe  'php::module_mysql'
include_recipe  'php-mcrypt::default'
include_recipe  'composer::default'
include_recipe  'phpunit::default'
include_recipe  'apache2::mod_php5'
include_recipe  'nodejs'
include_recipe  'foresttofarm-development::php'
include_recipe  'foresttofarm-development::web'
include_recipe  'foresttofarm-development::database'
