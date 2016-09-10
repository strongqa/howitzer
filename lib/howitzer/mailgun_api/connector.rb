require 'singleton'
require 'howitzer/mailgun_api/client'
require 'howitzer/exceptions'

module Howitzer
  module MailgunApi
    # This class represent connector to Mailgun service
    class Connector
      include Singleton

      attr_reader :api_key
      attr_accessor :domain

      # Assigns default value for a domain

      def initialize
        self.domain = Howitzer.mailgun_domain
      end

      # @return [Client] a mailgun client

      def client(api_key = Howitzer.mailgun_key)
        check_api_key(api_key)
        return @client if @api_key == api_key && @api_key
        @api_key = api_key
        @client = Client.new(api_key: @api_key)
      end

      private

      def check_api_key(api_key)
        Howitzer::Log.error InvalidApiKeyError, 'Api key can not be blank' if api_key.blank?
      end
    end
  end
end
