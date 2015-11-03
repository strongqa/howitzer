require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'
require 'yard'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'rubocop/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec) { |_spec| }

Cucumber::Rake::Task.new(:cucumber, 'Run all cucumber features') do |t|
  t.fork = false
end

YARD::Rake::YardocTask.new { |_t| }

RuboCop::RakeTask.new

task default: [:rubocop, :spec, :cucumber]
