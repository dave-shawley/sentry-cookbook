# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.box = "opscode-ubuntu-10.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-10.04_provisionerless.box"
  config.omnibus.chef_version = '11.6.0'

  config.berkshelf.berksfile_path = './Berksfile'
  config.berkshelf.enabled = true

  config.vm.define 'sentry-testing' do |box|
    box.vm.hostname = 'sentry-test'
    box.vm.network :private_network, ip: '33.33.33.10'
    box.vm.provision :chef_solo do |chef|
      chef.run_list = [
        'recipe[apt]',
        'recipe[bats-runner::install-bats]',
        'recipe[sentry::default]',
      ]
    end
  end
end
