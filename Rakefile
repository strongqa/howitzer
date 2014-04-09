require 'rubygems'
require "bundler"
Bundler.setup

require 'rake'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec) { |spec| }

Cucumber::Rake::Task.new(:cucumber, 'Run all cucumber features') do |t|
  t.fork = false
end

desc "All tests"
task(all_tests: [:spec, :cucumber]) {}

task :default => :all_tests
