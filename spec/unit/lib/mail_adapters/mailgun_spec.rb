require 'spec_helper'
require 'howitzer/email'
require 'howitzer/log'
require 'howitzer/exceptions'
require 'howitzer/mailgun_api/connector'

RSpec.describe 'Mailgun Email Adapter' do
  before do
    allow(Howitzer).to receive(:mail_adapter) { 'mailgun' }
    Howitzer::Email.adapter = 'mailgun'
  end
  let(:recipient) { 'first_tester@gmail.com' }
  let(:message) do
    {
      'body-plain' => 'test body footer',
      'stripped-html' => '<p> test body </p> <p> footer </p>',
      'stripped-text' => 'test body',
      'From' => 'Strong Tester <tester@gmail.com>',
      'To' => recipient,
      'Received' => 'by 10.216.46.75 with HTTP; Sat, 5 Apr 2014 05:10:42 -0700 (PDT)',
      'sender' => 'tester@gmail.com',
      'attachments' => []
    }
  end
  let(:message_subject) { 'test subject' }
  let(:mail_address) { double }
  let(:email_object) { Howitzer::Email.adapter.new(message) }

  before do
    stub_const('Howitzer::Email::SUBJECT', message_subject)
  end

  describe '.find' do
    let(:mailgun_message) { JSON.generate(message) }
    let(:events) { JSON.generate('items' => [event]) }
    before do
      FakeWeb.register_uri(:any, 'https://api:mailgun_account_private_key@api.mailgun.net/v3/' \
                                 'mailgun@test.domain/events?event=stored', body: events.to_s)
      FakeWeb.register_uri(:any, 'https://api:mailgun_account_private_key@si.api.mailgun.net/v3/' \
                                 'domains/mg.strongqa.com/messages/1234567890', body: mailgun_message.to_s)
    end
    subject { Howitzer::MailAdapters::Mailgun.find(recipient, message_subject, wait: 0.01) }

    context 'when message is found' do
      let(:event) do
        {
          'message' => {
            'recipients' => [recipient],
            'headers' => {
              'subject' => message_subject
            }
          },
          'storage' => {
            'key' => '1234567890',
            'url' => 'https://si.api.mailgun.net/v3/domains/mg.strongqa.com/messages/1234567890'
          }
        }
      end
      it do
        expect(Howitzer::Email.adapter).to receive(:new).with(message).once
        subject
      end
    end

    context 'when message is not found' do
      let(:event) do
        {
          'message' => {
            'recipients' => ['other@test.com'],
            'headers' => {
              'subject' => message_subject
            }
          },
          'storage' => {
            'key' => '1234567890',
            'url' => 'https://si.api.mailgun.net/v3/domains/mg.strongqa.com/messages/1234567890'
          }
        }
      end
      it do
        expect { subject }.to raise_error(
          Howitzer::EmailNotFoundError,
          "Message with subject '#{message_subject}' for recipient '#{recipient}' was not found."
        )
      end
    end
  end

  describe '#plain_text_body' do
    it { expect(email_object.plain_text_body).to eql message['body-plain'] }
  end

  describe '#html_body' do
    it { expect(email_object.html_body).to eql message['stripped-html'] }
  end

  describe '#text' do
    it { expect(email_object.text).to eql message['stripped-text'] }
  end

  describe '#mail_from' do
    it { expect(email_object.mail_from).to eql message['From'] }
  end

  describe '#recipients' do
    subject { email_object.recipients }
    it { is_expected.to be_a_kind_of Array }

    context 'when one recipient' do
      it { is_expected.to include message['To'] }
    end

    context 'when more than one recipient' do
      let(:second_recipient) { 'second_tester@gmail.com' }
      let(:message_with_multiple_recipients) { message.merge('To' => "#{recipient}, #{second_recipient}") }
      let(:email_object) { Howitzer::Email.adapter.new(message_with_multiple_recipients) }
      it { is_expected.to eql [recipient, second_recipient] }
    end
  end

  describe '#received_time' do
    it { expect(email_object.received_time).to eql message['Received'][27..63] }
  end

  describe '#sender_email' do
    it { expect(email_object.sender_email).to eql message['sender'] }
  end

  describe '#mime_part' do
    subject { email_object.mime_part }

    context 'when has attachments' do
      let(:files) { [double] }
      before { email_object.instance_variable_set(:@message, 'attachments' => files) }
      it { is_expected.to eq(files) }
    end

    context 'when no attachments' do
      it { is_expected.to eq([]) }
    end
  end

  describe '#mime_part!' do
    subject { email_object.mime_part! }

    context 'when has attachments' do
      let(:files) { [double] }
      before { email_object.instance_variable_set(:@message, 'attachments' => files) }
      it { is_expected.to eq(files) }
    end

    context 'when no attachments' do
      it do
        expect { subject }.to raise_error(Howitzer::NoAttachmentsError, 'No attachments were found.')
      end
    end
  end
end
