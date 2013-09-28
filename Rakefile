# -*- mode: ruby -*-
# vim: set ft=ruby :

require 'rspec/core/rake_task'


namespace :vendor do
  desc 'Remove vendor tree'
  task :clean do
    rmtree 'vendor'
  end

  desc '"Vendor" the cookbooks using berks'
  task :install do
    sh 'berks', 'install', '--path', 'vendor/cookbooks'
  end
end


namespace :spec do
  RSpec::Core::RakeTask.new :spec

  desc 'Run unit tests'
  task :unit => ['vendor:install', :spec]
end
