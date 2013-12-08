# -*- mode: ruby -*-
# vim: set ft=ruby :

require 'rspec/core/rake_task'


namespace :spec do
  desc 'Run unit tests'
  RSpec::Core::RakeTask.new :unit
end


desc 'Remove all of the generated files'
task 'maintainer-clean' do
  rmtree 'vendor'
  sh 'vagrant destroy -f'
  rmtree '.vagrant'
end
