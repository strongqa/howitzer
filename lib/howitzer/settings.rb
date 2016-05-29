require 'sexy_settings'

SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path('config/default.yml', Dir.pwd)
  config.path_to_custom_settings = File.expand_path('config/custom.yml', Dir.pwd)
end

##
#
# Returns settings as singleton object
#
# *Example:*
#
# +Howitzer.settings.app_host+
module Howitzer
  def settings
    ::SexySettings::Base.instance
  end
  module_function :settings

  ##
  #
  # Returns logger as singleton object
  #

  def log
    Log.instance
  end
  module_function :log
end
