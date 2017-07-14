require 'google/api_client/client_secrets'
require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'colorized_string'

module Howitzer
  module GmailApi
    # A GmailApi::Client object is used to communicate with the Gmail API.
    class Client
      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
      APPLICATION_NAME = Howitzer.gmail_app_name
      CLIENT_SECRETS_PATH = Howitzer.client_secret_path
      CREDENTIALS_PATH = File.join(Howitzer.log_dir, '.credentials',
                                   'howitzer-gmail.yaml')
      SCOPE = [Google::Apis::GmailV1::AUTH_GMAIL_MODIFY].freeze
      USER_ID = 'me'.freeze

      def initialize
        @service = Google::Apis::GmailV1::GmailService.new
        @service.client_options.application_name = APPLICATION_NAME
        @service.authorization = authorize
      end

      def find_message(recipient, subject)
        message_list = @service.list_user_messages(USER_ID, q: "to:#{recipient} subject:#{subject}")
        raise Howitzer::EmailNotFoundError, 'Message not received yet, retry...' if message_list.messages.nil?
        message_id = message_list.messages[0].id
        message = @service.get_user_message(USER_ID, message_id, format: 'full')
        message
      end

      def field_value(message, fieldname)
        message.payload.headers.each do |header|
          header.value if header.name == fieldname
        end
      end

      def get_attachments(message)
        attachments = []
        message.payload.parts.each { |part| attachments << part.filename unless part.body.attachment_id.nil? }
        attachments
      end

      private

      def authorize
        FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
        client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
        authorizer = Google::Auth::UserAuthorizer.new(
          client_id, SCOPE, token_store
        )
        user_id = 'default'
        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
          url = authorizer.get_authorization_url(
            base_url: OOB_URI
          )
          puts ColorizedString.new('Open the following URL in the browser and enter the ' \
               'resulting code after authorization').yellow
          puts url
          code = $stdin.gets
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
          )
        end
        credentials
      end
    end
  end
end
