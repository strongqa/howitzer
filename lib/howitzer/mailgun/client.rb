require 'rest_client'
require 'json'
require 'howitzer/mailgun/response'
require 'howitzer/exceptions'

module Mailgun

  # A Mailgun::Client object is used to communicate with the Mailgun API. It is a
  # wrapper around RestClient so you don't have to worry about the HTTP aspect
  # of communicating with our API.

  class Client

    def initialize(api_key, api_host="api.mailgun.net", api_version="v2", ssl=true)
      endpoint = endpoint_generator(api_host, api_version, ssl)
      @http_client = RestClient::Resource.new(endpoint,
                                              :user => "api",
                                              :password => api_key,
                                              :user_agent => "mailgun-sdk-ruby/1.0.1")
    end

    # Generic Mailgun GET Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with. Be sure to include your domain, where necessary.
    # @param [Hash] query_string This should be a standard Hash
    # containing required parameters for the requested resource.
    # @return [Mailgun::Response] A Mailgun::Response object.

    def get(resource_path, params=nil, accept="*/*")
      http_params = {:accept => accept}
      http_params = http_params.merge(params: params) if params
      response = @http_client[resource_path].get(http_params)
      Response.new(response)
    rescue => e
      log.error Howitzer::CommunicationError, e.message
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
