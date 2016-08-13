require 'rake'
require 'rake/clean'
require 'howitzer'
require 'howitzer/utils/log'
require 'rubocop/rake_task'

load 'howitzer/tasks/framework.rake'

Dir.chdir(File.join(__dir__, '.'))

RuboCop::RakeTask.new

if Howitzer.required_clean_logs
  CLEAN.include("#{Howitzer.log_dir}/*")
  Rake::Task[:clean].invoke
end

Dir['tasks/**/*.rake'].each { |rake| load rake }
ENV['RAKE_TASK'] = ARGV[0] if /^features/ === ARGV[0]
