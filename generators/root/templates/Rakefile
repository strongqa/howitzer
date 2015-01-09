require 'rake'
require 'rake/clean'
require 'howitzer/settings'
require 'howitzer/utils/log'

load 'howitzer/tasks/framework.rake'

Dir.chdir(File.join(File.dirname(__FILE__), '.'))

if settings.required_clean_logs
  CLEAN.include("#{settings.log_dir}/*")
  Rake::Task[:clean].invoke
end

Dir['tasks/**/*.rake'].each { |rake| load rake }
ENV['RAKE_TASK'] = ARGV[0] if /^(?:r?spec|cucumber)/ === ARGV[0]