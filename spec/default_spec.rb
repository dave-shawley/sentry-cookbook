require 'chefspec'
require File.expand_path('../support/helpers', __FILE__)


describe 'sentry::default' do

  it 'creates sentry user' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry']['user'] = 'configured-user'
    chef_run.node.set['sentry']['home'] = '/configured/home/dir'
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_user 'configured-user'
    user = chef_run.user 'configured-user'
    expect(user.home).to eq '/configured/home/dir'
  end

  it 'creates sentry group' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry']['admin_group'] = 'configured-group'
    chef_run.node.set['sentry']['admin_user'] = 'configured-user'
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
    chef_run.node.set['sentry']['home'] = '/configured/home/dir'
    chef_run.node.set['sentry']['user'] = 'configured-user'
    chef_run.node.set['sentry']['admin_group'] = 'configured-group'
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_directory '/configured/home/dir'
    dir = chef_run.directory '/configured/home/dir'
    expect(dir.owner).to eq 'configured-user'
    expect(dir.group).to eq 'configured-group'
    expect(dir.mode).to eq 0750
  end

  it 'creates sentry virtual environment' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry']['admin_group'] = 'configured-group'
    chef_run.node.set['sentry']['admin_user'] = 'admin-user'
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_python_virtualenv '/opt/sentry'
    env = chef_run.python_virtualenv '/opt/sentry'
    expect(env.owner).to eq 'admin-user'
    expect(env.group).to eq 'configured-group'
  end

  it 'installs sentry package' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry']['admin_group'] = 'configured-group'
    chef_run.node.set['sentry']['admin_user'] = 'admin-user'
    chef_run.node.set['sentry']['version'] = '6.6.6'
    chef_run.converge 'sentry::default'

    expect(chef_run).to install_python_pip 'sentry'
    pip_action = chef_run.python_pip 'sentry'
    expect(pip_action.virtualenv).to eq '/opt/sentry'
    expect(pip_action.user).to eq 'admin-user'
    expect(pip_action.group).to eq 'configured-group'
    expect(pip_action.version).to eq '6.6.6'
  end

  it 'creates sentry service' do
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set['sentry']['user'] = 'daemon-user'
    chef_run.node.set['sentry']['admin_group'] = 'admin-group'
    chef_run.node.set['sentry']['admin_user'] = 'admin-user'
    chef_run.node.set['sentry']['home'] = '/configured/home/dir'
    chef_run.converge 'sentry::default'

    expect(chef_run).to create_directory '/etc/opt/sentry'
    dir = chef_run.directory '/etc/opt/sentry'
    expect(dir.owner).to eq 'admin-user'
    expect(dir.group).to eq 'admin-group'
    expect(dir.mode).to eq 0775

    # The following does not work as expected
    #expect(chef_run).to create_if_missing_file '/etc/opt/sentry/conf.py'
    conf_file = chef_run.template '/etc/opt/sentry/conf.py'
    expect(conf_file.action).to eq [:create_if_missing]
    expect(conf_file.owner).to eq 'admin-user'
    expect(conf_file.group).to eq 'admin-group'
    expect(conf_file.mode).to eq 0660

    expect(chef_run).to enable_supervisor_service 'sentry'
    supervisor = chef_run.supervisor_service 'sentry'
    expect(supervisor.user).to eq 'daemon-user'
    expect(supervisor.command).to eq '/opt/sentry/bin/sentry start'
    expect(supervisor.action).to eq [:enable]
    expect(supervisor.autostart).to eq false
    expect(supervisor.environment[:SENTRY_CONF]).to eq '/etc/opt/sentry/conf.py'
  end

end
