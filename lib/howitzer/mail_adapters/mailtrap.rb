require 'howitzer/exceptions'
require 'howitzer/mail_adapters/abstract'
require 'howitzer/mailtrap_api/client'

module Howitzer
  module MailAdapters
    # This class represents mailtrap mail adapter
    class Mailtrap < Abstract
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
        message['text_body']
      end

      # @return [String] html body of the email message

      def html_body
        message['html_body']
      end

      # @return [String] stripped text

      def text
        message['text_body']
      end

      # @return [String] an email address specified in `From` field

      def mail_from
        message['from_email']
      end

      # @return [String] recipient emails separated with `, `

      def recipients
        message['to_email'].split ', '
      end

      # @return [String] when email was received

      def received_time
        Time.parse(message['created_at']).to_s
      end

      # @return [String] a real sender email address

      def sender_email
        message['from_email']
      end

      # @return [Array] attachments

      def mime_part
        retrieve_attachments(message)
      end

      # @raise [NoAttachmentsError] if no attachments present
      # @return [Array] attachments

      def mime_part!
        files = mime_part
        return files if files.present?

        raise Howitzer::NoAttachmentsError, 'No attachments were found.'
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
        message = Howitzer::MailtrapApi::Client.new.find_message(recipient, subject)
        raise Howitzer::EmailNotFoundError, 'Message not received yet, retry...' unless message

        message
      end
      private_class_method :retrieve_message

      private

      def retrieve_attachments(message)
        Howitzer::MailtrapApi::Client.new.find_attachments(message)
      end
    end
  end
end
