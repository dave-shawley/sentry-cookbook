require 'chefspec'


module ChefSpec
  class ChefRunner
    def python_virtualenv(name)
      find_resource 'python_virtualenv', name
    end
  end

  module Matchers
    define_resource_matchers([:create, :delete], [:python_virtualenv], :name)
  end
end


describe 'sentry::default' do

  it 'installs sentry requirements' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.converge 'sentry::default'

    expect(chef_run).to install_package 'python-setuptools'
  end

  it 'creates sentry user' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry']['user'] = 'configured-user'
    chef_run.node.set['sentry_home'] = '/configured/home/dir'
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_user 'configured-user'
    user = chef_run.user 'configured-user'
    expect(user.home).to eq '/configured/home/dir'
  end

  it 'creates sentry group' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry_group'] = 'configured-group'
    chef_run.node.set['sentry']['user'] = 'configured-user'
    chef_run.converge  'sentry::default'

    expect(chef_run).to create_group 'configured-group'
    group = chef_run.group 'configured-group'
    expect(group.members).to eq ['configured-user']
  end

  it 'uses sensible default user attributes' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_user 'sentry'
    user = chef_run.user 'sentry'
    expect(user.system).to be_true
    expect(user.shell).to eq '/bin/false'
    expect(user.gid).to eq 'daemon'
    expect(user.home).to eq '/var/sentry'
  end

  it 'creates sentry home directory' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry_home'] = '/configured/home/dir'
    chef_run.node.set['sentry']['user'] = 'configured-user'
    chef_run.node.set['sentry_group'] = 'configured-group'
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_directory '/configured/home/dir'
    dir = chef_run.directory '/configured/home/dir'
    expect(dir.owner).to eq 'configured-user'
    expect(dir.group).to eq 'configured-group'
    expect(dir.mode).to eq 0750
  end

  it 'creates sentry virtual environment' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry_group'] = 'configured-group'
    chef_run.node.set['sentry_admin'] = 'admin-user'
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_python_virtualenv '/opt/sentry'
    env = chef_run.python_virtualenv '/opt/sentry'
    expect(env.owner).to eq 'admin-user'
    expect(env.group).to eq 'configured-group'
  end

  it 'installs sentry package' do
    pending 'should install into virtualenv'
  end

  it 'creates sentry service' do
    pending 'TODO'
  end

end
