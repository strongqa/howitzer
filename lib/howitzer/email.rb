require 'rspec/matchers'
require 'howitzer/exceptions'

module Howitzer
  # This class describes single email
  class Email
    include ::RSpec::Matchers

    attr_reader :message

    # @return [<MailAdapters::Abstract>] a mail adapter class

    def self.adapter
      return @adapter if @adapter

      self.adapter = Howitzer.mail_adapter.to_sym
      @adapter
    end

    class << self
      attr_reader :adapter_name

      protected

      # DSL method to specify a subject pattern directly in an email class
      # @param value [String] an email subject with optional placeholders (strings started with : symbol)
      # @example
      #   class WelcomeEmail < Howitzer::Email
      #     subject 'Welcome on board :name'
      #   end
      #
      #   WelcomeEmail.find_by_recipient('john.smith@example.com', name: 'John')
      # @!visibility public

      def subject(value)
        define_singleton_method(:subject_value) { value }
        private_class_method :subject_value
      end

      # DSL method to specify a custom wait email time directly in an email class
      # @param value [Integer] an wait time for a particular email.
      #   If it is ommitted, default Howitzer.mail_wait_time will be used.
      # @example
      #   class WelcomeEmail < Howitzer::Email
      #     wait_time 10.minutes
      #   end
      # @!visibility public

      def wait_time(value)
        define_singleton_method(:wait_time_value) { value }
        private_class_method :wait_time_value
      end
    end

    wait_time Howitzer.try(:mail_wait_time)

    # Specifies a mail adapter
    # @param adapter_name [String, Symbol] an email adapter name
    # @raise [NoMailAdapterError] when the adapter name is not String or Symbol

    def self.adapter=(adapter_name)
      @adapter_name = adapter_name
      case adapter_name
        when Symbol, String
          require "howitzer/mail_adapters/#{adapter_name}"
          @adapter = MailAdapters.const_get(adapter_name.to_s.capitalize.to_s)
        else
          raise Howitzer::NoMailAdapterError
      end
    end

    # Searches a mail by a recepient
    # @param recipient [String] recepient's email address
    # @param params [Hash] placeholders with appropriate values
    # @raise [NoEmailSubjectError] when a subject is not specified for the email class
    # @return [Email] an instance of the email message
    # @see .subject

    def self.find_by_recipient(recipient, params = {})
      if defined?(subject_value).nil? || subject_value.nil?
        raise Howitzer::NoEmailSubjectError, "Please specify email subject. For example:\n" \
                                             "class SomeEmail < Howitzer::Email\n  " \
                                             "subject ‘some subject text’\nend"
      end
      new(adapter.find(recipient, expand_subject(params), wait: wait_time_value))
    end

    def initialize(message)
      @message = message
    end

    # @return [String, nil] a plain text of the email message

    def plain_text_body
      message.plain_text_body
    end

    # @return [String, nil] a html body of the email message

    def html_body
      message.html_body
    end

    # @return [String, nil] a mail text

    def text
      message.text
    end

    # @return [String] who has sent the email data in format: User Name <user@email>

    def mail_from
      message.mail_from
    end

    # @return [Array<String>] array of recipients who has received current email

    def recipients
      message.recipients
    end

    # @return [String] email received time

    def received_time
      message.received_time
    end

    # @return [String] a sender user email

    def sender_email
      message.sender_email
    end

    # Allows to get email MIME attachment

    def mime_part
      message.mime_part
    end

    def self.expand_subject(params)
      params.inject(subject_value.dup) { |a, (k, v)| a.sub(":#{k}", v.to_s) }
    end
    private_class_method :expand_subject
  end
end
