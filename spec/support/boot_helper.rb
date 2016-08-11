require 'sexy_settings'
SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path('default.yml', File.join(File.dirname(__FILE__), '..', 'config'))
  config.path_to_custom_settings = File.expand_path('custom.yml', File.join(File.dirname(__FILE__), '..', 'config'))
end

def settings
  SexySettings::Base.instance
end

def log
  Howitzer::Utils::Log.instance
end

def Howitzer.app_uri
  ::Addressable::URI.new(
    user: settings.app_base_auth_login,
    password: settings.app_base_auth_pass,
    host: settings.app_host,
    scheme: settings.app_protocol || 'http'
  )
end

def Howitzer.cache
  Howitzer::Utils::DataStorage
end

ENV['TEST_MODE'] = 'TRUE'
