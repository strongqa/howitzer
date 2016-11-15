require 'rest-client'
require 'json'
require 'howitzer/mailgun_api/response'
require 'howitzer/exceptions'

module Howitzer
  module MailgunApi
    # A Mailgun::Client object is used to communicate with the Mailgun API. It is a
    # wrapper around RestClient so you don't have to worry about the HTTP aspect
    # of communicating with Mailgun API.
    class Client
      USER_AGENT = 'mailgun-sdk-ruby'.freeze #:nodoc:
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
      # @param resource_path [String] this is the API resource you wish to interact
      #   with. Be sure to include your domain, where it is necessary.
      # @param params [Hash] this should be a standard Hash for query
      #   containing required parameters for the requested resource.
      # @raise [CommunicationError] if something went wrong
      # @return [Mailgun::Response] a Mailgun::Response object.

      def get(resource_path, params: nil, accept: '*/*')
        http_params = { accept: accept }
        http_params = http_params.merge(params: params) if params
        response = http_client[resource_path].get(http_params)
        Response.new(response)
      rescue => e
        raise Howitzer::CommunicationError, e.message
      end

      # Extracts data by url in custom way
      # @note This method was introducted because of saving emails to different nodes.
      #   As result we can not use {#get} method, because client holds general api url
      #
      # @param resource_url [String] a full url
      # @param params [Hash] this should be a standard Hash for query
      #   containing required parameters for the requested resource.
      # @param accept [String] an accept pattern for headers
      # @raise [CommunicationError] if something went wrong
      # @return [Mailgun::Response] a Mailgun::Response object.

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
        raise Howitzer::CommunicationError, e.message
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
