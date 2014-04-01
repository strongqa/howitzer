require 'rspec/matchers'
require 'mailgun'

class Email
  include RSpec::Matchers

  @@mg_client = Mailgun::Client.new settings.mailgun_key
  @@domain = settings.mailgun_domain

  ##
  #
  # Creates new email with message
  #
  # *Parameters:*
  # * +message+ - email message
  #

  def initialize(message)
    @message = message
  end

  ##
  #
  # Search mail by recepient
  #
  # *Parameters:*
  # * +recepient+ - recepient's email address
  #

  def self.find_by_recipient(recipient)
    find(recipient, self::SUBJECT)
  end

  ##
  #
  # Search mail by recepient and subject.
  #
  # *Parameters:*
  # * +recepient+ - recepient's email address
  # * +subject+ - email subject
  #

  def self.find(recipient, subject)
    message = {}
    retryable(tries: 10, logger: log, sleep: 1, trace: true, on: Exception) do
      events = @@mg_client.get("#{@@domain}/events", event: 'stored')
      message_key = events.to_h['items'].find{|hash| hash['message']['recipients'].first == recipient && hash['message']['headers']['subject'] == subject}['storage']['key']
      message = @@mg_client.get "domains/#{@@domain}/messages/#{message_key}"
    end

    unless message
      log.error "Message with subject '#{subject}' for recipient '#{recipient}' was not found."
      return
    end

    new(message.to_h)
  end

  ##
  #
  # Returns plain text body of email message
  #

  def plain_text_body
    @message['body-plain']
  end

  ##
  #
  # Returns html body of email message
  #

  def html_body
    @message['stripped-html']
  end

  ##
  #
  # Returns who has send email data in format: User Name <user@email>
  #

  def mail_from
    @message['From']
  end

  ##
  #
  # Returns array of recipients who has received current email
  #

  def recipients
    @message['To'].split ', '
  end

  ##
  #
  # Returns email received time in format:
  #

  def received_time
    @message['Received'][/\w+, \d+ \w+ \d+ \d+:\d+:\d+ -\d+ \(\w+\)$/]
  end

  ##
  #
  # Returns sender user email
  #

  def sender_email
    @message['sender']
  end

  ##
  #
  # Allows to get email MIME attachment
  #

  def get_mime_part
    files = @message['attachments']
    unless files.empty?
      log.error "No attachments where found."
      return
    end
    files
  end

  protected :get_mime_part
end