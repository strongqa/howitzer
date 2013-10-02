require 'sexy_settings'

SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path("config/default.yml", Dir.pwd)
  config.path_to_custom_settings = File.expand_path("config/custom.yml", Dir.pwd)
end

##
#
# Get setting value from settings file ( custom,yml or default.yml)
# Example : +settings.app_host+
# TODO doesn't appear in RDoc generated files maybe because of this code not enclosed into class or module

def settings
  SexySettings::Base.instance
end

##
#
# Returns log instance
#

def log
  Howitzer::Log.instance
end