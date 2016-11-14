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
    # Defines methods for all known settings
    # @example
    #  Howtzer.app_host
    #  Howitzer.driver

    ::SexySettings::Base.instance.all.each do |key, value|
      define_method(key) { value }
    end

    # @deprecated

    def mailgun_idle_timeout
      puts "WARNING! 'mailgun_idle_timeout' setting is deprecated. Please replace with 'mail_wait_time' setting."
      ::SexySettings::Base.instance.all['mailgun_idle_timeout']
    end

    attr_accessor :current_rake_task
  end

  # @return an application uri
  #
  # @example returns url with auth
  #  app_uri.site
  # @example returns url without auth
  #  app_uri.origin

  def self.app_uri
    ::Addressable::URI.new(
      user: Howitzer.app_base_auth_login,
      password: Howitzer.app_base_auth_pass,
      host: Howitzer.app_host,
      scheme: Howitzer.app_protocol || 'http'
    )
  end
end

require 'howitzer/version'
require 'howitzer/exceptions'
require 'howitzer/log'
require 'howitzer/utils'
require 'howitzer/cache'
require 'howitzer/email'
require 'howitzer/web'
require 'howitzer/capybara_helpers'
