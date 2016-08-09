require 'selenium-webdriver'
require 'capybara'
require 'sexy_settings'

SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path('config/default.yml', Dir.pwd)
  config.path_to_custom_settings = File.expand_path('config/custom.yml', Dir.pwd)
end

# This is main namespace for the library
module Howitzer
  def self.settings
    ::SexySettings::Base.instance
  end
  ##
  #
  # Returns logger as singleton object
  #

  def self.log
    Log.instance
  end

  ##
  #
  # Returns application uri
  #
  # uri.site - returns url with auth
  # uri.origin -returns url without auth
  #

  def self.app_uri
    ::Addressable::URI.new(
      user: settings.app_base_auth_login,
      password: settings.app_base_auth_pass,
      host: settings.app_host,
      scheme: settings.app_protocol || 'http'
    )
  end

  # describe me!
  def self.cache
    Howitzer::Utils::DataStorage
  end
end

require 'howitzer/version'
require 'howitzer/utils/log'
require 'howitzer/helpers'
require 'howitzer/utils'
require 'howitzer/helpers'
require 'howitzer/email'
require 'howitzer/web'
