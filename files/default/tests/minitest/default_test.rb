require File.expand_path('../support/helpers', __FILE__)

describe 'sentry::default' do

  include Helpers::Sentry

  it 'creates the sentry user' do
    user('sentry').must_exist.with(:group, 'daemon')
    directory('/var/sentry') \
      .must_exist \
      .with(:owner, 'sentry').and(:group, 'sentry')
  end

  it 'creates the administrative group' do
    group('sentry').must_exist
  end

  it 'creates a virtualenv for sentry' do
    directory('/opt/sentry') \
      .must_exist \
      .with(:owner, 'root').and(:group, 'sentry') \
      .with_permissions(0025)
    lookup_resource('python_virtualenv[/opt/sentry]') \
      .must_exist \
      .with(:owner, 'root') \
      .and(:group, 'sentry')
  end

  it 'installs sentry into the virtualenv' do
    lookup_resource('python_pip[sentry]') \
      .must_exist \
      .with(:virtualenv, '/opt/sentry') \
      .and(:user, 'root').and(:group, 'sentry') \
      .and(:version, nil)  # nil <=> latest
    file('/opt/sentry/bin/sentry') \
      .must_exist \
      .with_permissions(0555)
  end

  it 'configures sentry' do
    directory('/etc/opt/sentry') \
      .must_exist \
      .with(:group, 'sentry') \
      .with_permissions(0070)
    file('/etc/opt/sentry/conf.py') \
      .must_exist \
      .with(:group, 'sentry') \
      .with_permissions(0060)
  end

end
