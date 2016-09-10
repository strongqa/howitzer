require 'howitzer/exceptions'

module Howitzer
  module MailgunApi
    # A MailgunApi::Response object is instantiated for each response generated
    # by the Client request. The Response object supports deserialization of
    # the JSON result.
    class Response
      attr_accessor :body
      attr_accessor :code

      def initialize(response)
        @body = response.body
        @code = response.code
      end

      # Return a response as a Ruby Hash
      # @raise [ParseError] in case of an json parsing error
      # @return [Hash] HTTP result as hash.

      def to_h
        JSON.parse(@body)
      rescue StandardError => e
        Howitzer::Log.error ParseError, e.message
      end
    end
  end
end
