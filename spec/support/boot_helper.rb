require 'sexy_settings'

SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path("default.yml", File.join(File.dirname(__FILE__), '..', 'config'))
end

def settings
  SexySettings::Base.instance()
end

#require 'howitzer'