require 'selenium-webdriver'
require 'capybara'
require 'sexy_settings'

SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path('config/default.yml', Dir.pwd)
  config.path_to_custom_settings = File.expand_path('config/custom.yml', Dir.pwd)
end

# This is main namespace for the library
module Howitzer
  class << self
    # define methods for all known settings
    ::SexySettings::Base.instance.all.each do |key, value|
      define_method(key) { value }
    end
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
      user: Howitzer.app_base_auth_login,
      password: Howitzer.app_base_auth_pass,
      host: Howitzer.app_host,
      scheme: Howitzer.app_protocol || 'http'
    )
  end

  # describe me!
  def self.cache
    Howitzer::Utils::DataStorage
  end
end

require 'howitzer/version'
require 'howitzer/log'
require 'howitzer/utils'
require 'howitzer/email'
require 'howitzer/web'
