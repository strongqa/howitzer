module Howitzer
  module GmailApi
    # A GmailApi::Client object is used to communicate with the Gmail API.
    class Client
      def self.load_gmail_gem!
        require 'gmail'
      rescue LoadError
        raise LoadError, "Unable to load `gmail` library, please add following code to your Gemfile:\n\ngem 'gmail'"
      end
      load_gmail_gem!

      def initialize
        self.client = Gmail.connect(Howitzer.gmail_login, Howitzer.gmail_password)
      end

      # Finds message according to given parameters
      #
      # @param recipient [String] this is recipient mail address for message filtering
      # @param subject [String] this is subject of the message to filter particular message
      # @return [Gmail::Message] gmail message object

      def find_message(recipient, subject)
        client.inbox.emails(to: recipient, subject: subject).last
      end

      private

      attr_accessor :client
    end
  end
end
