module MailAdapters
  # This class holds abstract mail adapter methods
  class Abstract
    attr_reader :message

    def self.find(_recipient, _subject)
      fail NotImplementedError
    end

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
    # Returns plain text body of email message
    #

    def plain_text_body
      fail NotImplementedError
    end

    ##
    #
    # Returns html body of email message
    #

    def html_body
      fail NotImplementedError
    end

    ##
    #
    # Returns mail text
    #

    def text
      fail NotImplementedError
    end

    ##
    #
    # Returns who has send email data in format: User Name <user@email>
    #

    def mail_from
      fail NotImplementedError
    end

    ##
    #
    # Returns array of recipients who has received current email
    #

    def recipients
      fail NotImplementedError
    end

    ##
    #
    # Returns email received time in format:
    #

    def received_time
      fail NotImplementedError
    end

    ##
    #
    # Returns sender user email
    #

    def sender_email
      fail NotImplementedError
    end

    ##
    #
    # Allows to get email MIME attachment
    #

    def mime_part
      fail NotImplementedError
    end
  end
end
