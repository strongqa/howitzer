require 'sexy_settings'
SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path("config/default.yml", Dir.pwd)
  config.path_to_custom_settings = File.expand_path("config/custom.yml", Dir.pwd)
end

def settings
  SexySettings::Base.instance()
end


Dir[File.join(File.dirname(__FILE__), "./utils/**/*.rb")].each {|f| require f}