require 'sexy_settings'
SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path('default.yml', File.join(File.dirname(__FILE__), '..', 'config'))
  config.path_to_custom_settings = File.expand_path('custom.yml', File.join(File.dirname(__FILE__), '..', 'config'))
end

def settings
  SexySettings::Base.instance
end

def log
  Howitzer::Log.instance
end

ENV['TEST_MODE'] = 'TRUE'
