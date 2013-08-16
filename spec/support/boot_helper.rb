ENV['TEST_MODE'] = true

def settings
  SexySettings::Base.instance()
end

SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path("default.yml", File.join(File.dirname(__FILE__), '..', 'config'))
end

require 'howitzer'