#
# Cookbook Name:: rails_vagrant
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe  'apt::default'
include_recipe  'rails_vagrant::ruby'
include_recipe  'rails_vagrant::apache2'
include_recipe  'rails_vagrant::rails'
include_recipe  'rails_vagrant::virtual_host'
include_recipe  'rails_vagrant::database'
include_recipe  'rails_vagrant::database_schema'
