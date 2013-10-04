require File.expand_path('../support/helpers', __FILE__)

describe 'sentry::default' do

  include Helpers::Sentry

  it 'creates the sentry user' do
    user('sentry').must_exist.with('group', group('daemon').gid)
    directory('/var/sentry').must_exist.with('owner', 'sentry').and('group', 'sentry')
  end

  it 'creates the administrative group' do
    group('sentry').must_exist
  end

  it 'creates a virtualenv for sentry' do
    directory('/opt/sentry') \
      .must_exist \
      .with('owner', 'sentry').and('group', 'sentry') \
      .with_permissions(0020)
    file('/opt/sentry/bin/activate').must_exist
    file('/opt/sentry/bin/python').must_exist
  end

end
