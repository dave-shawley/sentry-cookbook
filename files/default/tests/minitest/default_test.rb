require File.expand_path('../support/helpers', __FILE__)

describe 'sentry::default' do

  include Helpers::Sentry

  it 'creates the sentry user' do
    user('sentry').must_exist
  end

end
