require 'selenium-webdriver'
require 'capybara'
require 'sexy_settings'
require 'rspec/wait'
require 'howitzer/version'
require 'howitzer/exceptions'

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

    # @return active session name

    def session_name
      @session_name ||= 'default'
    end

    # Sets new session name
    #
    # @param name [String] string identifier for the session
    #
    # @example Executing code in another browser
    # Howitzer.session_name = 'browser2'
    # LoginPage.on do
    #   expect(title).to eq('Login Page')
    # end
    #
    # # Switching back to main browser
    # Howitzer.session_name = 'default'

    def session_name=(name)
      @session_name = name
      Capybara.session_name = @session_name
    end

    # Yield a block using a specific session name
    #
    # @param name [String] string identifier for the session
    #
    # @example Opening page in another browser
    # Howitzer.using_session('browser2') do
    #   LoginPage.on do
    #     expect(title).to eq('Login Page')
    #   end
    # end

    def using_session(name)
      Capybara.using_session(name) { yield }
    end

    attr_accessor :current_rake_task
  end

  # @return an application uri for particular application name
  #
  # @param name [Symbol, String] an application name from framework settings
  #
  # @example returns default application url with auth
  #  app_uri.site
  # @example returns example application url with auth
  #  app_uri(:example).site
  # @example returns default application url without auth
  #  app_uri.origin

  def self.app_uri(name = nil)
    prefix = "#{name}_" if name.present?
    ::Addressable::URI.new(
      user: Howitzer.sexy_setting!("#{prefix}app_base_auth_login"),
      password: Howitzer.sexy_setting!("#{prefix}app_base_auth_pass"),
      host: Howitzer.sexy_setting!("#{prefix}app_host"),
      scheme: Howitzer.sexy_setting!("#{prefix}app_protocol") || 'http'
    )
  end

  # @return an setting value or raise error
  #
  # @param name [Symbol, String] an setting name
  # @raise [Howitzer::UndefinedSexySettingError] when the setting is not specified

  def self.sexy_setting!(name)
    return Howitzer.public_send(name) if Howitzer.respond_to?(name)

    raise UndefinedSexySettingError,
          "Undefined '#{name}' setting. Please add the setting to config/default.yml:\n #{name}: some_value\n"
  end
end

require 'howitzer/log'
require 'howitzer/utils'
require 'howitzer/cache'
require 'howitzer/email'
require 'howitzer/web'
require 'howitzer/capybara_helpers'
