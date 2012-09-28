require 'howitzer'

Dir.chdir(File.join(File.dirname(__FILE__), '..'))

def settings
  SexySettings::Base.instance()
end

if settings.required_clean_logs
  require 'rake/clean'
  CLEAN.include("#{settings.log_dir}/*")
  Rake::Task[:clean].invoke
end

Dir[File.join(File.dirname(__FILE__), "./emails/*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "./pages/*.rb")].each {|f| require f}