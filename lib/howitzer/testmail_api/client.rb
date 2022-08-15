require 'json'
require 'rest-client'

module Howitzer
  module TestmailApi
    # A Testmail::Client object is used to communicate with the testmail.app API.
    class Client
      BASE_URL = "https://api.testmail.app/api/json?apikey=#{Howitzer.testmail_api_key}" \
                 "&namespace=#{Howitzer.testmail_namespace}".freeze # :nodoc:

      def initialize
        @api_token = Howitzer.testmail_api_key
      end

      # Finds message according to given parameters
      #
      # @param recipient [String] this is recipient mail address for message filtering
      # @param subject [String] this is subject of the message to filter particular message
      # @return [Hash] json message parsed to ruby hash

      def find_message(recipient, subject)
        recipient = recipient.gsub(/.*\.([^@]+)@.*/, '\1')
        messages = filter_by_subject(messages(recipient), subject)
        latest_message(messages)
      end

      private

      def messages(recipient)
        JSON.parse(RestClient.get("#{BASE_URL}&tag=#{recipient}"))
      end

      def latest_message(messages)
        messages[0]
      end

      def filter_by_subject(messages, subject)
        result_messages = []
        messages['emails'].each { |msg| result_messages << msg if msg['subject'] == subject }
        result_messages
      end
    end
  end
end
