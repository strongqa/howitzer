require 'rspec/matchers'
require 'howitzer/exceptions'

module Howitzer
  # This class describes single email
  class Email
    include ::RSpec::Matchers

    attr_reader :message

    ##
    #
    # Return mail adapter class
    #

    def self.adapter
      return @adapter if @adapter
      self.adapter = settings.mail_adapter.to_sym
      @adapter
    end

    ##
    #
    # Return mail adapter name
    #

    class << self
      attr_reader :adapter_name
      attr_writer :subject
    end

    def self.expand_subject(*args)
      args.each { |k, v| @subject.sub!(":#{k}", v) }
    end
    ##
    #
    # Specify mail adapter
    #
    # *Parameters:*
    # * +adapter_name+ - adapter name as string or symbol
    #

    def self.adapter=(adapter_name)
      @adapter_name = adapter_name
      case adapter_name
        when Symbol, String
          require "howitzer/mail_adapters/#{adapter_name}"
          @adapter = MailAdapters.const_get(adapter_name.to_s.capitalize.to_s)
        else
          raise NoMailAdapterError
      end
    end

    def self.subject(value)
      @subject = value
    end

    ##
    #
    # Search mail by recepient
    #
    # *Parameters:*
    # * +recepient+ - recepient's email address
    #

    def self.find_by_recipient(recipient, *args)
      raise NoSubjectError, "Please specify email subject. For example:
                             class SomeEmail < Howitzer::Email\n subject ‘some subject text’\nend" if args.nil?
      new(adapter.find_by_recipient(recipient, expand_subject(args)))
    end

    ##
    #
    # Search mail by recepient and subject.
    #
    # *Parameters:*
    # * +recepient+ - recepient's email address
    # * +subject+ - email subject
    #

    # def self.find(recipient, subject)
    #   new(adapter.find(recipient, subject))
    # end

    def initialize(message)
      @message = message
    end

    ##
    #
    # Returns plain text body of email message
    #

    def plain_text_body
      message.plain_text_body
    end

    ##
    #
    # Returns html body of email message
    #

    def html_body
      message.html_body
    end

    ##
    #
    # Returns mail text
    #

    def text
      message.text
    end

    ##
    #
    # Returns who has send email data in format: User Name <user@email>
    #

    def mail_from
      message.mail_from
    end

    ##
    #
    # Returns array of recipients who has received current email
    #

    def recipients
      message.recipients
    end

    ##
    #
    # Returns email received time in format:
    #

    def received_time
      message.received_time
    end

    ##
    #
    # Returns sender user email
    #

    def sender_email
      message.sender_email
    end

    ##
    #
    # Allows to get email MIME attachment
    #

    def mime_part
      message.mime_part
    end
  end
end
