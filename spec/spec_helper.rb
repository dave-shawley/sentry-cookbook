# Pull in some commonly used libraries.
require 'chefspec'

# ChefSpec sets up the Chef cookbook_path so that it includes the
# vendor/cookbooks directory.  The following chunk of code uses the
# Berkshelf goodness to install our dependencies there before the
# tests are run and remove them after our tests have completed.
begin
  require 'berkshelf'
  berks = ::Berkshelf::Berksfile.from_file 'Berksfile'
  RSpec.configure do |config|
    config.before(:suite) do
      FileUtils.rm_rf 'vendor/cookbooks'
      berks.install path: 'vendor/cookbooks'
    end
    config.after(:suite) do
      FileUtils.rm_rf 'vendor/cookbooks'
    end
  end
rescue LoadError
end
