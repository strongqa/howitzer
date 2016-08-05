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
      USER_AGENT = 'mailgun-sdk-ruby'.freeze
      attr_reader :api_user, :api_key, :api_host, :api_version, :ssl
      def initialize(api_user: 'api', api_key:, api_host: 'api.mailgun.net', api_version: 'v3', ssl: true)
        @api_user = api_user
        @api_key = api_key
        @api_host = api_host
        @api_version = api_version
        @ssl = ssl
        @http_client = ::RestClient::Resource.new(endpoint, user: api_user, password: api_key, user_agent: USER_AGENT)
      end

      # Generic Mailgun GET Handler
      #
      # @param [String] resource_path This is the API resource you wish to interact
      # with. Be sure to include your domain, where necessary.
      # @param [Hash] params This should be a standard Hash for query
      # containing required parameters for the requested resource.
      # @return [Mailgun::Response] A Mailgun::Response object.

      def get(resource_path, params: nil, accept: '*/*')
        http_params = { accept: accept }
        http_params = http_params.merge(params: params) if params
        response = http_client[resource_path].get(http_params)
        Response.new(response)
      rescue => e
        log.error CommunicationError, e.message
      end

      # describe me!
      def get_url(resource_url, params: nil, accept: '*/*')
        response = ::RestClient::Request.execute(
          method: :get,
          url: resource_url,
          user: api_user,
          password: api_key,
          user_agent: USER_AGENT,
          accept: accept,
          params: params
        )
        Response.new(response)
      rescue => e
        log.error CommunicationError, e.message
      end

      private

      attr_reader :http_client

      def endpoint
        scheme = "http#{'s' if ssl}"
        res = "#{scheme}://#{api_host}"
        res << "/#{api_version}" if api_version
        res
      end
    end
  end
end
