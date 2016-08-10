require 'rake'
require 'rake/clean'
require 'howitzer'
require 'howitzer/utils/log'
require 'rubocop/rake_task'

load 'howitzer/tasks/framework.rake'

Dir.chdir(File.join(File.dirname(__FILE__), '.'))

RuboCop::RakeTask.new

if Howitzer.settings.required_clean_logs
  CLEAN.include("#{Howitzer.settings.log_dir}/*")
  Rake::Task[:clean].invoke
end

Dir['tasks/**/*.rake'].each { |rake| load rake }
ENV['RAKE_TASK'] = ARGV[0] if /^features/ === ARGV[0]
