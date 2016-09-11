require 'howitzer/mailgun_api/connector'
require 'howitzer/exceptions'
require 'howitzer/mail_adapters/abstract'

module Howitzer
  module MailAdapters
    # This class represents Mailgun mail adapter
    class Mailgun < Abstract
      # Finds an email in storage
      # @note emails are stored for 3 days only!
      # @param recipient [String] an email
      # @param subject [String]
      # @raise [EmailNotFoundError] if message blank

      def self.find(recipient, subject)
        message = {}
        retryable(find_retry_params) { message = retrieve_message(recipient, subject) }
        return new(message) if message.present?
        raise Howitzer::EmailNotFoundError,
              "Message with subject '#{subject}' for recipient '#{recipient}' was not found."
      end

      # @return [String] plain text body of the email message

      def plain_text_body
        message['body-plain']
      end

      # @return [String] html body of the email message

      def html_body
        message['stripped-html']
      end

      # @return [String] stripped text

      def text
        message['stripped-text']
      end

      # @return [String] an email address specified in `From` field

      def mail_from
        message['From']
      end

      # @return [String] recipient emails separated with `, `

      def recipients
        message['To'].split ', '
      end

      # @return [String] when email was received

      def received_time
        message['Received'][/\w+, \d+ \w+ \d+ \d+:\d+:\d+ -\d+ \(\w+\)$/]
      end

      # @return [String] a real sender email address

      def sender_email
        message['sender']
      end

      # @return [Array] attachments

      def mime_part
        message['attachments']
      end

      # @raise [NoAttachmentsError] if no attachments present
      # @return [Array] attachments

      def mime_part!
        files = mime_part
        return files if files.present?
        raise Howitzer::NoAttachmentsError, 'No attachments where found.'
      end

      def self.events
        MailgunApi::Connector.instance.client.get(
          "#{MailgunApi::Connector.instance.domain}/events", params: { event: 'stored' }
        )
      end
      private_class_method :events

      def self.event_by(recipient, subject)
        events.to_h['items'].find do |hash|
          hash['message']['recipients'].first == recipient && hash['message']['headers']['subject'] == subject
        end
      end
      private_class_method :event_by

      def self.find_retry_params
        {
          timeout: Howitzer.mailgun_idle_timeout,
          sleep: Howitzer.mailgun_sleep_time,
          silent: true,
          logger: Howitzer::Log,
          on: Howitzer::EmailNotFoundError
        }
      end
      private_class_method :find_retry_params

      def self.retrieve_message(recipient, subject)
        event = event_by(recipient, subject)
        raise Howitzer::EmailNotFoundError, 'Message not received yet, retry...' unless event

        message_url = event['storage']['url']
        MailgunApi::Connector.instance.client.get_url(message_url).to_h
      end
      private_class_method :retrieve_message
    end
  end
end
