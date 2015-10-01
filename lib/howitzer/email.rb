require 'rspec/matchers'
require 'howitzer/exceptions'

class Email
  include RSpec::Matchers

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

  def self.adapter_name
    @adapter_name
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
        @adapter = ::MailAdapters.const_get("#{adapter_name.to_s.capitalize}")
      else
        raise Howitzer::NoMailAdapterError
    end
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
    adapter.find(recipient, subject)
  end

end