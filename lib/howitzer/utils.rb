require 'sexy_settings'

SexySettings.configure do |config|
  config.path_to_default_settings = "config/default.yml"
  config.path_to_custom_settings = "config/custom.yml"
end

def settings
  SexySettings::Base.instance()
end

Dir[File.join(File.dirname(__FILE__), "./utils/**/*.rb")].each {|f| require f}