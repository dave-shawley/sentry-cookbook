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

end
