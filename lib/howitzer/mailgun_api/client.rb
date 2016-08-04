require 'rest-client'
require 'json'
require 'howitzer/mailgun_api/response'
require 'howitzer/exceptions'

module Howitzer
  module MailgunApi
    # A Mailgun::Client object is used to communicate with the Mailgun API. It is a
    # wrapper around RestClient so you don't have to worry about the HTTP aspect
    # of communicating with our API.
    class Client
      def initialize(api_key, api_host = 'api.mailgun.net', api_version = 'v3', ssl = true)
        endpoint = endpoint_generator(api_host, api_version, ssl)
        @http_client = ::RestClient::Resource.new(endpoint,
                                                  user: 'api',
                                                  password: api_key,
                                                  user_agent: 'mailgun-sdk-ruby/1.0.1')
      end

      # Generic Mailgun GET Handler
      #
      # @param [String] resource_path This is the API resource you wish to interact
      # with. Be sure to include your domain, where necessary.
      # @param [Hash] params This should be a standard Hash for query
      # containing required parameters for the requested resource.
      # @return [Mailgun::Response] A Mailgun::Response object.

      def get(resource_path, params = nil, accept = '*/*; q=0.5, application/xml')
        http_params = { accept: accept }
        http_params = http_params.merge(params: params) if params
        response = rp(tries: 10, on: RestClient::BadRequest) do
          @http_client[resource_path].get(http_params)
        end
        Response.new(response)
      rescue => e
        log.error CommunicationError, e.message
      end

      private

      def endpoint_generator(api_host, api_version, ssl)
        scheme = "http#{'s' if ssl}"
        res = "#{scheme}://#{api_host}"
        res << "/#{api_version}" if api_version
        res
      end
    end
  end
end
