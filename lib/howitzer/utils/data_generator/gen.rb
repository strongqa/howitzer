module DataGenerator
  module Gen

    ##
    #
    # This module generates uniq User object with uniq generated data.
    # Examples:
    # member = Gen::user                          #user.email: 'u<XXXX>@<settings.mail_pop3_domain>'
    # member = Gen::user('user@test.com')         #user.email: 'member@test.com'
    # member = Gen::user(settings.def_test_user)  #user.email: settings.def_test_user

    class << self

      ##
      #
      # Generates new User object with generated data.
      #
      # *Attributes:*
      # * +params+ - Custom parameters
      #
      # *Returns:*
      # * +user+ - New generated User object
      #


      def user(params={})
        prefix = serial
        default = {
            email: gen_user_email(prefix),
            login: nil,
            first_name: gen_first_name(prefix),
            last_name: gen_last_name(prefix),
            password: settings.def_test_pass
        }
        User.new(default.merge(params))
      end

      ##
      #
      # Gets User object by it's number
      #
      # *Attributes:*
      # * +num+ - User number
      #
      # *Returns:*
      # * +user+ - User object
      #

      def given_user_by_number(num)
        data = DataStorage.extract('user', num.to_i)
        unless data
          data = Gen::user
          DataStorage.store('user', num.to_i, data)
        end
        data
      end

      ##
      #
      # Generates uniq string
      # @return [String]                          Generated string
      #
      # *Returns:*
      # * +string+ - Generated string
      #

      def serial
        a = [('a'..'z').to_a, (0..9).to_a].flatten.shuffle
        "#{Time.now.utc.strftime("%j%H%M%S")}#{a[0..4].join}"
      end

      ##
      #
      # Deletes mailboxes for all users that were generated before
      #

      def delete_all_mailboxes
        DataStorage.extract('user').each_value do |user|
          user.delete_mailbox
        end
      end

      private

      def gen_user_email(serial=nil)
        "#{gen_user_name(serial)}@#{settings.mail_pop3_domain}"
      end

      def gen_user_name(serial=nil)
        gen_entity('u', serial)
      end

      def gen_first_name(serial=nil)
        gen_entity('FirstName', serial)
      end

      def gen_last_name(serial=nil)
        gen_entity('LastName', serial)
      end

      def gen_entity(prefix, serial)
        "#{prefix}#{serial.nil? ? self.serial : serial}"
      end
    end

    class User < Object

      attr_reader :login, :domain, :email, :password, :mailbox, :first_name, :last_name, :full_name

      def initialize(params={})
        @email = params.delete(:email)
        @email_name, @domain = @email.to_s.split('@')
        @login = params.delete(:login) || @email_name
        @password = params.delete(:password)
        @first_name = params.delete(:first_name)
        @last_name = params.delete(:last_name)
        @full_name = "#@first_name #@last_name"
        @mailbox = params.delete(:mailbox)
      end

      def create_mailbox
        @mailbox = MailClient.create_mailbox(@email_name) if settings.mail_pop3_domain == @domain
        self
      end

      def delete_mailbox
        MailClient.delete_mailbox(@mailbox) unless @mailbox.nil?
      end
    end
  end
end