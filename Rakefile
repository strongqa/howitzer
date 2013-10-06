require 'rubygems'
require "bundler"
Bundler.setup

require 'rake'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec) { |spec| }
task :default => :spec
