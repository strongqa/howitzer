require 'sexy_settings'
SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path('default.yml', File.join(__dir__, '..', 'config'))
  config.path_to_custom_settings = File.expand_path('custom.yml', File.join(__dir__, '..', 'config'))
end

def settings
  SexySettings::Base.instance
end

def log
  Howitzer::Utils::Log.instance
end
