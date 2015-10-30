require 'howitzer/mailgun/connector'
require 'howitzer/exceptions'
require 'howitzer/mail_adapters/abstract'

module MailAdapters
  class Mailgun < Abstract
    def self.find(recipient, subject)
      @message = {}
      message_event(recipient, subject)
      retryable(
        timeout: settings.timeout_small,
        sleep: settings.timeout_short,
        silent: true,
        logger: log,
        on: ::Howitzer::EmailNotFoundError
      ) do
        init_message(recipient, subject)
      end
      log_error if @message.empty?
      new(@message)
    end

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

    private

    def init_message(recipient, subject)
      event_obj = event(recipient, subject)
      if event_ojb
        @message = ::Mailgun::Connector.instance.client.get(
          "domains/#{::Mailgun::Connector.instance.domain}/messages/#{event_obj['storage']['key']}").to_h
      else
        fail ::Howitzer::EmailNotFoundError, 'Message not received yet, retry...'
      end
    end

    def event(recipient, subject)
      stored_events.to_h['items'].find do |hash|
        hash['message']['recipients'].first == recipient && hash['message']['headers']['subject'] == subject
      end
    end

    def stored_events
      ::Mailgun::Connector.instance.client.get("#{::Mailgun::Connector.instance.domain}/events", event: 'stored')
    end

    def log_error
      log.error(::Howitzer::EmailNotFoundError,
                "Message with subject '#{subject}' for recipient '#{recipient}' was not found.")
    end
  end
end
