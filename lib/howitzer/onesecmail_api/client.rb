require 'json'
require 'rest-client'

module Howitzer
  module OnesecmailApi
    # A Onesecmail::Client object is used to communicate with the 1secMail API.
    class Client
      BASE_URL = 'https://www.1secmail.com/api/v1/'.freeze # :nodoc:

      # Finds message according to given parameters
      #
      # @param recipient [String] this is recipient mail address for message filtering
      # @param subject [String] this is subject of the message to filter particular message
      # @return [Hash] json message parsed to ruby hash

      def find_message(recipient, subject)
        messages = filter_by_subject(recipient[/[^@]+/], subject)
        latest_message(messages)
      end

      private

      def messages(recipient_name)
        JSON.parse(RestClient.get("#{BASE_URL}?action=getMessages&login=#{recipient_name}" \
                                  "&domain=#{Howitzer.onesecmail_domain}"))
      end

      def latest_message(messages)
        messages[0]
      end

      def filter_by_subject(recipient_name, subject)
        result_messages = []
        messages(recipient_name).each do |msg|
          if msg['subject'] == subject
            result_messages << JSON.parse(RestClient.get("#{BASE_URL}?action=readMessage&login=#{recipient_name}" \
                                                         "&domain=#{Howitzer.onesecmail_domain}&id=#{msg['id']}"))
          end
        end
        result_messages
      end
    end
  end
end
