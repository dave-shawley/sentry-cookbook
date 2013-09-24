# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.hostname = 'sentry-berkshelf'

  config.vm.box = 'lucid64'
  config.vm.box_url = 'http://files.vagrantup.com/lucid64.box'

  config.vm.network :private_network, ip: '33.33.33.10'

  config.berkshelf.berksfile_path = './Berksfile'
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
    }
    chef.run_list = [
        'recipe[minitest-handler::default]',
        'recipe[sentry::default]',
    ]
  end

end
