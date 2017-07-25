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
        message.body.to_s
      end

      # @return [String] html body of the email message

      def html_body
        message.html_part.to_s
      end

      # @return [String] stripped text

      def text
        message.text_part.to_s
      end

      # @return [String] an email address specified in `From` field

      def mail_from
        "#{message.from[0]['mailbox']}@#{message.from[0]['host']}"
      end

      # @return [Array] recipient emails

      def recipients
        res = []
        message.to.each { |to| res << "#{to['mailbox']}@#{to['host']}" }
        res
      end

      # @return [String] when email was received

      def received_time
        Time.parse(message.date).strftime('%F %T')
      end

      # @return [Array] attachments

      def mime_part
        message.attachments
      end

      # @raise [NoAttachmentsError] if no attachments present
      # @return [Array] attachments

      def mime_part!
        files = mime_part
        return files if files.present?
        raise Howitzer::NoAttachmentsError, 'No attachments were found.'
      end

      def self.get_message(recipient, subject)
        message = Howitzer::GmailApi::Client.new.find_message(recipient, subject)
        raise Howitzer::EmailNotFoundError if message.blank?
        message
      end
      private_class_method :get_message

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
    end
  end
end
