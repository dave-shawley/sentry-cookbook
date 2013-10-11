# -*- mode: ruby -*-
# vi: set ft=ruby :
#


def apply_chef_cache_workaround(chef)
  # Re: https://github.com/mitchellh/vagrant/issues/2281
  chef.provisioning_path = "/tmp/vagrant-chef-solo"
  chef.file_cache_path = chef.provisioning_path
end


Vagrant.configure('2') do |config|

  config.berkshelf.berksfile_path = './Berksfile'
  config.berkshelf.enabled = true

  config.vm.define 'sentry-lucid' do |box|
    box.vm.hostname = 'sentry-lucid'
    box.vm.box = 'lucid64'
    box.vm.box_url = 'http://files.vagrantup.com/lucid64.box'
    box.vm.network :private_network, ip: '33.33.33.10'
    box.vm.provision :chef_solo do |chef|
      apply_chef_cache_workaround chef
      chef.run_list = [
        'recipe[minitest-handler::default]',
        'recipe[sentry::default]',
      ]
    end
  end

end
