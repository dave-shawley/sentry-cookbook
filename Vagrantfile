# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|


  config.vm.box = 'lucid64'
  config.vm.box_url = 'http://files.vagrantup.com/lucid64.box'


  config.berkshelf.berksfile_path = './Berksfile'
  config.berkshelf.enabled = true

  config.vm.define 'sentry-testing' do |box|
    box.vm.hostname = 'sentry-test'
    box.vm.network :private_network, ip: '33.33.33.10'
    box.vm.provision :chef_solo do |chef|
      chef.run_list = [
        'recipe[minitest-handler::default]',
        'recipe[sentry::default]',
      ]
    end
  end
end
