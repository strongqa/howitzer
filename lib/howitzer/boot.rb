require 'rubygems'
require 'bundler/setup'
require 'sexy_settings'

Dir.chdir(File.join(File.dirname(__FILE__), '..'))

def settings
  SexySettings::Base.instance()
end

if settings.required_clean_logs
  require 'rake/clean'
  CLEAN.include("#{settings.log_dir}/*")
  Rake::Task[:clean].invoke
end

#create symlink for cucumber config
system "ln -s shared/lib/config config" unless File.symlink?('config')