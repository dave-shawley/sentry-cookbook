# -*- mode: ruby -*-
# vim: set ft=ruby :

require 'berkshelf'
require 'rspec/core/rake_task'


namespace :vendor do
  desc 'Remove vendor tree'
  task :clean do
    rmtree 'vendor'
  end

  desc '"Vendor" the cookbooks using berks'
  task :install do
    berks = Berkshelf::Berksfile.from_file 'Berksfile'
    berks.install :path => 'vendor/cookbooks'
  end
end


namespace :spec do
  RSpec::Core::RakeTask.new :spec

  desc 'Run unit tests'
  task :unit => ['vendor:install', :spec]
end


desc 'Remove all of the generated files'
task 'maintainer-clean' do
  Rake::Task['vendor:clean'].execute
  sh %q{vagrant destroy -f}
  rmtree '.vagrant'
  rmtree 'tmp'
end
