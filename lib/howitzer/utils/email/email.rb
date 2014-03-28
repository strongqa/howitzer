require 'rspec/matchers'
require 'mailgun'

class Email
  include RSpec::Matchers

  @@mg_client = Mailgun::Client.new settings.mailgun_api_key
  @@domain = settings.mail_smtp_domain

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
    events = @@mg_client.get("#{@@domain}/events", event: 'stored')
    message_key = events.to_h['items'].find{|hash| hash['message']['recipients'].first == recipient && hash['message']['headers']['subject'] == subject}['storage']['key']
    message = @@mg_client.get "domains/#{@@domain}/messages/#{message_key}"

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
