require 'singleton'
require 'howitzer/mailgun/client'
require 'howitzer/exceptions'

module Mailgun
  # A Mailgun::Connector object is used for connection with Client
  class Connector
    include Singleton

    attr_reader :api_key

    def client(api_key = settings.mailgun_key)
      check_api_key(api_key)
      if @api_key == api_key && @api_key
        @client
      else
        @api_key = api_key
        @client = Mailgun::Client.new(@api_key)
      end
    end

    def domain
      @domain || change_domain
    end

    def change_domain(domain_name = settings.mailgun_domain)
      @domain = domain_name
    end

    private

    def check_api_key(api_key)
      log.error Howitzer::InvalidApiKeyError, 'Api key can not be blank' if api_key.blank?
    end
  end
end
