# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.network "private_network", ip: "192.168.34.34"

    # Give the vagrant share more memory.  If we don't do this, it runs out of
    # RAM in the MySQL provisioning stage.
    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
    end

    # Chef provisioning using vagrant-berkshelf plugin and chef_solo
    config.berkshelf.enabled = true
    config.berkshelf.berksfile_path = "cookbooks/rails_vagrant/Berksfile"

    config.vm.provision "chef_solo" do |chef|
      chef.add_recipe "rails_vagrant::default"
    end

    # There are issues with vagrant shares and symlinks.
    #
    # http://stackoverflow.com/questions/24200333/symbolic-links-and-synced-folders-in-vagrant
    #
    # A simple work around, since this is just a local development environment,
    # is to share the whole folder right where we need it.
    #
    config.vm.synced_folder ".", "/srv/www/application", group:  'www-data', owner: 'www-data'
end
