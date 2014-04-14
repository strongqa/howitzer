module Mailgun
  # A Mailgun::Response object is instantiated for each response generated
  # by the Client request. The Response object supports deserialization of
  # the JSON result.

  class Response

    attr_accessor :body
    attr_accessor :code

    def initialize(response)
      @body = response.body
      @code = response.code
    end

    # Return response as Ruby Hash
    #
    # @return [Hash] A standard Ruby Hash containing the HTTP result.

    def to_h
      JSON.parse(@body)
    rescue Exception => e
      raise ParseError.new(e)
    end
  end
end