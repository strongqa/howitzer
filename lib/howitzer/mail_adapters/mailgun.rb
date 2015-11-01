require 'howitzer/mailgun/connector'
require 'howitzer/exceptions'
require 'howitzer/mail_adapters/abstract'

module MailAdapters
  class Mailgun < Abstract
    def self.find(recipient, subject)
      message = {}
      retryable(find_retry_params) { message = retrieve_message(recipient, subject) }
      log.error(
        ::Howitzer::EmailNotFoundError,
        "Message with subject '#{subject}' for recipient '#{recipient}' was not found."
      ) if message.empty?
      new(message)
    end

    def self.events
      ::Mailgun::Connector.instance.client.get("#{::Mailgun::Connector.instance.domain}/events", event: 'stored')
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
        timeout: settings.timeout_small,
        sleep: settings.timeout_short,
        silent: true,
        logger: log,
        on: ::Howitzer::EmailNotFoundError
      }
    end
    private_class_method :find_retry_params

    def self.retrieve_message(recipient, subject)
      event = event_by(recipient, subject)
      fail ::Howitzer::EmailNotFoundError, 'Message not received yet, retry...' unless event

      message_url = "domains/#{::Mailgun::Connector.instance.domain}/messages/#{event['storage']['key']}"
      ::Mailgun::Connector.instance.client.get(message_url).to_h
    end
    private_class_method :retrieve_message

    def plain_text_body
      message['body-plain']
    end

    def html_body
      message['stripped-html']
    end

    def text
      message['stripped-text']
    end

    def mail_from
      message['From']
    end

    def recipients
      message['To'].split ', '
    end

    def received_time
      message['Received'][/\w+, \d+ \w+ \d+ \d+:\d+:\d+ -\d+ \(\w+\)$/]
    end

    def sender_email
      message['sender']
    end

    def mime_part
      files = message['attachments']
      if files.empty?
        log.error ::Howitzer::NoAttachmentsError, 'No attachments where found.'
        return
      end
      files
    end
  end
end
