require 'howitzer/exceptions'
require 'howitzer/mail_adapters/abstract'
require 'howitzer/onesecmail_api/client'

module Howitzer
  module MailAdapters
    # This class represents 1secMail mail adapter
    class Onesecmail < Abstract
      # Finds an email in storage
      # @param recipient [String] an email
      # @param subject [String]
      # @param wait [Integer] how much time is required to wait an email
      # @raise [EmailNotFoundError] if blank message

      def self.find(recipient, subject, wait:)
        message = {}
        retryable(find_retry_params(wait)) { message = retrieve_message(recipient, subject) }
        return new(message) if message.present?

        raise Howitzer::EmailNotFoundError,
              "Message with subject '#{subject}' for recipient '#{recipient}' was not found."
      end

      # @return [String] plain text body of the email message

      def plain_text_body
        message['body']
      end

      # @return [String] html body of the email message

      def html_body
        message['htmlBody']
      end

      # @return [String] stripped text

      def text
        message['textBody']
      end

      # @return [String] an email address specified in `From` field

      def mail_from
        message['from']
      end

      # @return [String] when email was received

      def received_time
        Time.parse(message['date']).to_s
      end

      # @return [String] a real sender email address

      def sender_email
        message['from']
      end

      def self.find_retry_params(wait)
        {
          timeout: wait,
          sleep: Howitzer.mail_sleep_time,
          silent: true,
          logger: Howitzer::Log,
          on: Howitzer::EmailNotFoundError
        }
      end
      private_class_method :find_retry_params

      def self.retrieve_message(recipient, subject)
        message = Howitzer::OnesecmailApi::Client.new.find_message(recipient, subject)
        raise Howitzer::EmailNotFoundError, 'Message not received yet, retry...' unless message

        message
      end
      private_class_method :retrieve_message
    end
  end
end
