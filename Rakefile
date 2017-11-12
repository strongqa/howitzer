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

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new { |_t| }

namespace :yard do
  desc 'Validate yard coverage'
  task :validate do
    log = StringIO.new
    YARD::Logger.instance(log)
    doc = YARD::CLI::Yardoc.new
    doc.use_document_file = false
    doc.use_yardopts_file = false
    doc.generate = false
    doc.run('--list-undoc')
    output = log.string
    puts output
    return if output.include?('100.00% documented')
    exit(-1)
  end
end

task default: %i[rubocop yard:validate spec cucumber]
