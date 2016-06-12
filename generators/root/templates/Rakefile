require 'rake'
require 'rake/clean'
require 'howitzer/settings'
require 'howitzer/utils/log'

load 'howitzer/tasks/framework.rake'

Dir.chdir(File.join(File.dirname(__FILE__), '.'))

if Howitzer.settings.required_clean_logs
  CLEAN.include("#{Howitzer.settings.log_dir}/*")
  Rake::Task[:clean].invoke
end

Dir['tasks/**/*.rake'].each { |rake| load rake }
ENV['RAKE_TASK'] = ARGV[0] if /^features/ === ARGV[0]
