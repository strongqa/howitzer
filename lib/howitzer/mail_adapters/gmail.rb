require 'howitzer/exceptions'
require 'howitzer/mail_adapters/abstract'
require 'howitzer/gmail_api/client'

module Howitzer
  module MailAdapters
    # This class represents Gmail mail adapter
    class Gmail < Abstract
      # Finds an email in storage
      # @param recipient [String] an email
      # @param subject [String]
      # @param wait [Integer] how much time is required to wait an email
      # @raise [EmailNotFoundError] if blank message

      def self.find(recipient, subject, wait:)
        message = {}
        retryable(find_retry_params(wait)) { message = get_message(recipient, subject) }
        return new(message) if message.present?
        raise Howitzer::EmailNotFoundError,
              "Message with subject '#{subject}' for recipient '#{recipient}' was not found."
      end

      # @return [String] plain text body of the email message

      def plain_text_body
        if message.payload.parts.nil?
          message.payload.body.data
        else
          message.payload.parts[0].body.data
        end
      end

      # @return [String] html body of the email message

      def html_body
        if message.payload.parts.nil?
          message.payload.body.data
        else
          message.payload.parts[1].body.data
        end
      end

      # @return [String] stripped text

      def text
        if message.payload.parts.nil?
          message.payload.body.data
        else
          message.payload.parts[0].body.data
        end
      end

      # @return [String] an email address specified in `From` field

      def mail_from
        get_field_value('From')
      end

      # @return [Array] recipient emails

      def recipients
        get_field_value('To').split ', '
      end

      # @return [String] when email was received

      def received_time
        get_field_value('Date')
      end

      # @return [Array] attachments

      def mime_part
        attachment_list
      end

      # @raise [NoAttachmentsError] if no attachments present
      # @return [Array] attachments

      def mime_part!
        files = mime_part
        return files if files.present?
        raise Howitzer::NoAttachmentsError, 'No attachments where found.'
      end

      def self.get_message(recipient, subject)
        client = Howitzer::GmailApi::Client.new
        client.find_message(recipient, subject)
      end
      private_class_method :get_message

      def get_field_value(fieldname)
        client = Howitzer::GmailApi::Client.new
        client.field_value(@message, fieldname)
      end

      def attachment_list
        client = Howitzer::GmailApi::Client.new
        client.get_attachments(@message)
      end

      def self.find_retry_params(wait)
        {
          timeout: wait || Howitzer.try(:gmail_idle_timeout),
          sleep: Howitzer.gmail_sleep_time,
          silent: true,
          logger: Howitzer::Log,
          on: Howitzer::EmailNotFoundError
        }
      end
      private_class_method :find_retry_params
    end
  end
end
