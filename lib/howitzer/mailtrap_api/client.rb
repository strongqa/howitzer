require 'json'
require 'rest-client'

module Howitzer
  module MailtrapApi
    # A Mailtrap::Client object is used to communicate with the Mailtrap API.
    class Client
      BASE_URL = "https://mailtrap.io/api/v1/inboxes/#{Howitzer.mailtrap_inbox_id}".freeze
      def initialize
        @api_token = Howitzer.mailtrap_api_token
      end

      # Finds message according to given parameters
      #
      # @param recipient [String] this is recipient mail address for message filtering
      # @param subject [String] this is subject of the message to filter particular message
      # @return [Hash] json message parsed to ruby hash

      def find_message(recipient, subject)
        recipient = recipient.gsub('+', '%2B')
        messages = filter_by_subject(messages(recipient), subject)
        latest_message(messages)
      end

      # Finds attachments for message
      #
      # @param message [Hash] which attachments should be extracted
      # @return [Array] returns array of attachments

      def find_attachments(message)
        JSON.parse(RestClient.get("#{BASE_URL}/messages/#{message['id']}/attachments", 'Api-Token' => @api_token))
      end

      private

      def messages(recipient)
        JSON.parse(RestClient.get("#{BASE_URL}/messages?search=#{recipient}", 'Api-Token' => @api_token))
      end

      def latest_message(messages)
        messages[0]
      end

      def filter_by_subject(messages, subject)
        result_messages = []
        messages.each { |msg| result_messages << msg if msg['subject'] == subject }
        result_messages
      end
    end
  end
end
