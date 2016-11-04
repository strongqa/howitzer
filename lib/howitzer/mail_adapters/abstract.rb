module Howitzer
  module MailAdapters
    # +Abstract+ is the superclass of all mail adapters.
    #
    # @abstract This class should not be used directly. Instead, create a
    #  subclass that implements:
    #  {.find}
    #  {#plain_text_body}
    #  {#html_body}
    #  {#text}
    #  {#mail_from}
    #  {#recipients}
    #  {#received_time}
    #  {#sender_email}
    #  {#mime_part}
    class Abstract
      attr_reader :message

      # Finds an email in mailbox
      # @param _recipient [String] an email
      # @param _subject [String]

      def self.find(_recipient, _subject)
        raise NotImplementedError
      end

      # Creates a new instance of email

      # @param message [Object] original message data

      def initialize(message)
        @message = message
      end

      # Returns a plain text body of the email message

      def plain_text_body
        raise NotImplementedError
      end

      # Returns a html body of the email message

      def html_body
        raise NotImplementedError
      end

      # Returns a mail text

      def text
        raise NotImplementedError
      end

      # Returns who has sent email data in format: User Name <user@email>

      def mail_from
        raise NotImplementedError
      end

      # Returns an array of recipients who has received current email

      def recipients
        raise NotImplementedError
      end

      # Returns email received time

      def received_time
        raise NotImplementedError
      end

      # Returns sender user email

      def sender_email
        raise NotImplementedError
      end

      # Allows to get email MIME attachment

      def mime_part
        raise NotImplementedError
      end
    end
  end
end
