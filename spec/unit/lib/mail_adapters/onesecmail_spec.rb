require 'spec_helper'
require 'howitzer/email'
require 'howitzer/log'
require 'howitzer/exceptions'
RSpec.describe '1secMail Email Adapter' do
  before do
    allow(Howitzer).to receive(:mail_adapter) { 'onesecmail' }
    Howitzer::Email.adapter = 'onesecmail'
    allow(Howitzer).to receive(:onesecmail_domain) { '1secmail.com' }
    base_url = 'https://www.1secmail.com/api/v1/'
    stub_const('Howitzer::TestmailApi::Client::BASE_URL', base_url)
    FakeWeb.register_uri(:get,
                         "#{base_url}?action=getMessages&login=#{recipient[/[^@]+/]}" \
                         "&domain=#{Howitzer.onesecmail_domain}",
                         body: '[{"id":1,"subject":"Confirmation instructions"}]')
    FakeWeb.register_uri(:get,
                         "#{base_url}?action=readMessage&login=#{recipient[/[^@]+/]}" \
                         "&domain=#{Howitzer.onesecmail_domain}&id=1",
                         body: message.to_s.gsub('=>', ':'))
  end
  let(:recipient) { 'test@mail.com' }
  let(:mail_subject) { 'Confirmation instructions' }
  let(:message) do
    {
      'id' => '1',
      'from' => 'noreply@test.com',
      'subject' => 'Confirmation instructions',
      'date' => '2022-08-16 10:29:41',
      'attachments' => [],
      'body' => '<p> Test Email! </p>',
      'htmlBody' => '<p> Test Email! </p>',
      'textBody' => 'Test Email!'
    }
  end
  let(:email_object) { Howitzer::Email.adapter.new(message) }

  describe '.find' do
    subject { Howitzer::MailAdapters::Onesecmail.find(recipient, mail_subject, wait: 0.01) }
    context 'when message is found' do
      it do
        expect(Howitzer::Email.adapter).to receive(:new).with(message).once
        subject
      end
    end

    context 'when message is not found' do
      let(:mail_subject) { 'Wrong subject' }
      it do
        expect { subject }.to raise_error(
          Howitzer::EmailNotFoundError,
          "Message with subject '#{mail_subject}' for recipient '#{recipient}' was not found."
        )
      end
    end
  end

  describe '#plain_text_body' do
    it { expect(email_object.plain_text_body).to eql message['body'] }
  end

  describe '#html_body' do
    it { expect(email_object.html_body).to eql message['htmlBody'] }
  end

  describe '#text' do
    it { expect(email_object.text).to eql message['textBody'] }
  end

  describe '#received_time' do
    it { expect(email_object.received_time).to eql Time.parse(message['date']).to_s }
  end

  describe '#sender_email' do
    it { expect(email_object.sender_email).to eql message['from'] }
  end
end
