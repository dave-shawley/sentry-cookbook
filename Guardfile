require 'berkshelf'
require 'guard/rspec'

guard :shell do
  watch(%r{^(attributes|recipes)/.+\.rb$}) do
	berks = Berkshelf::Berksfile.from_file 'Berksfile'
	berks.install :path => 'vendor/cookbooks'
	rspec = RSpec::Runner.new :cli => '--color --drb'
	rspec.run ['spec']
  end
end

guard :rspec, :cli => '--color --drb' do
  watch(%r{^spec/.+_spec\.rb$})
end

