require 'gmail'

module Howitzer
  module GmailApi
    # A GmailApi::Client object is used to communicate with the Gmail API.
    class Client

      def initialize
        @@client ||= Gmail.connect(Howitzer.gmail_login, Howitzer.gmail_password)
      end

      # Finds message according to given parameters
      #
      # @param recipient [String] this is recipient mail address for message filtering
      # @param subject [String] this is subject of the message to filter particular message
      # @return [Gmail::Message] gmail message object

      def find_message(recipient, subject)
        @@client.inbox.emails(to: recipient, subject: subject).last
      end

    end
  end
end
