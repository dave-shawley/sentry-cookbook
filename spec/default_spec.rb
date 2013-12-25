# -*- coding: UTF-8 -*-
require 'spec_helper'

describe 'sentry::default' do
  let(:chef_run) do
    stub_command("/usr/bin/python -c 'import setuptools'").and_return true
    ChefSpec::Runner.new
  end

  it 'installs sentry requirements' do
    chef_run.converge described_recipe

    expect(chef_run).to install_package 'python-setuptools'
  end

  it 'creates sentry user' do
    chef_run.node.set['sentry']['user'] = 'configured-user'
    chef_run.node.set['sentry']['home'] = '/configured/home/dir'
    chef_run.converge described_recipe

    expect(chef_run).to create_user('configured-user').with(
      home: '/configured/home/dir',
    )
  end

  it 'creates sentry group' do
    chef_run.node.set['sentry']['admin_group'] = 'configured-group'
    chef_run.node.set['sentry']['admin_user'] = 'configured-user'
    chef_run.converge described_recipe

    expect(chef_run).to create_group('configured-group').with(
      members: ['configured-user'],
    )
  end

  it 'uses sensible default user attributes' do
    chef_run.converge described_recipe

    expect(chef_run).to create_user('sentry').with(
      system: true,
      shell: '/bin/false',
      gid: 'daemon',
      home: '/var/sentry',
    )
  end

  it 'creates sentry home directory' do
    chef_run.node.set['sentry']['home'] = '/configured/home/dir'
    chef_run.node.set['sentry']['user'] = 'configured-user'
    chef_run.node.set['sentry']['admin_group'] = 'configured-group'
    chef_run.converge described_recipe

    expect(chef_run).to create_directory('/configured/home/dir').with(
      owner: 'configured-user',
      group: 'configured-group',
      mode: 00750,
    )
  end

  it 'creates sentry virtual environment' do
    chef_run.node.set['sentry']['admin_group'] = 'configured-group'
    chef_run.node.set['sentry']['admin_user'] = 'admin-user'
    chef_run.converge described_recipe

    expect(chef_run).to create_python_virtualenv('/opt/sentry').with(
      owner: 'admin-user',
      group: 'configured-group',
    )
  end
end
