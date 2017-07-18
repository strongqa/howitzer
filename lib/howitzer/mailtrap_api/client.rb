require 'json'
require 'rest-client'

module Howitzer
  module MailtrapApi
    # A Mailtrap::Client object is used to communicate with the Mailtrap API. It is a
    class Client
      def initialize
        @base_url = "https://mailtrap.io/api/v1/inboxes/#{Howitzer.inbox_id}"
        @api_token = Howitzer.api_token
      end

      def find_message(recipient, subject)
        recipient = URI.escape(recipient, '+')
        messages = filter_by_subject(messages(recipient), subject)
        latest_message(messages)
      end

      def find_attachments(message)
        JSON.parse(RestClient.get("#{@base_url}/messages/#{message['id']}/attachments", 'Api-Token' => @api_token))
      end

      private

      def messages(recipient)
        JSON.parse(RestClient.get("#{@base_url}/messages?search=#{recipient}", 'Api-Token' => @api_token))
      end

      def latest_message(messages)
        messages[0]
      end

      def filter_by_subject(messages, subject)
        result_messages = []
        messages.each { |msg| result_messages << msg if msg['subject'].match?(subject) }
        result_messages
      end
    end
  end
end
