require "time"
require "json"
require 'howitzer/exceptions'

module Mailgun
  class UnitClient

    attr_reader :url, :options, :block, :body, :code

    def initialize(url, options={}, backwards_compatibility=nil, &block)
      @url = url
      @block = block
      @options = options
      @body = nil
      @code = nil
    end

    def [](resource_path, &new_block)
      case
        when block_given? then self.class.new(resource_path, options, &new_block)
        when block        then self.class.new(resource_path, options, &block)
        else
          self.class.new(resource_path, options)
      end
    end

    def get(options, query_string = nil)
      begin
        if query_string

          response = response_generator("bounces")
        else
          response = response_generator("bounces")
        end
        Response.new(response)
      rescue Exception => e
        log.error Howitzer::CommunicationError.new(e), e.response
      end
    end

    private

    def response_generator(resource_endpoint)
      case resource_endpoint
        when "messages"
          t = Time.now
          id = "<#{t.to_i}.#{rand(99999999)}.5817@example.com>"
          @body = JSON.generate({"message" => "Queued. Thank you.", "id" => id})
        when "bounces"
          @body = JSON.generate({"total_count" => 1, "items" => {"created_at" => "Fri, 21 Oct 2011 11:02:55 GMT", "code" => 550, "address" => "baz@example.com", "error" => "Message was not accepted -- invalid mailbox. Local mailbox baz@example.com is unavailable: user not found"}})
        when "lists"
          @body = JSON.generate({"member" => {"vars" => {"age" => 26}, "name" => "Foo Bar", "subscribed" => false, "address" => "bar@example.com"}, "message" => "Mailing list member has been updated"})
        when "campaigns"
          @body = JSON.generate({"message" => "Campaign has been deleted", "id" => "ABC123"})
      end
      self
    end
  end

end
