require 'spec_helper'
require 'howitzer/email'
require 'howitzer/log'
require 'howitzer/exceptions'
RSpec.describe 'Testmail.app Email Adapter' do
  before do
    allow(Howitzer).to receive(:mail_adapter) { 'testmail' }
    Howitzer::Email.adapter = 'testmail'
    allow(Howitzer).to receive(:testmail_api_key) { 'apikey' }
    allow(Howitzer).to receive(:testmail_namespace) { 'namespace' }
    base_url = 'https://api.testmail.app/api/json?apikey=apikey&namespace=namespace'
    stub_const('Howitzer::TestmailApi::Client::BASE_URL', base_url)
    FakeWeb.register_uri(:get, "#{base_url}&tag=#{recipient}", body: "{\"emails\":[#{message.to_s.gsub('=>', ':')}]}")
  end
  let(:recipient) { 'test@mail.com' }
  let(:mail_subject) { 'Confirmation instructions' }
  let(:message) do
    {
      'id' => '20813-5jms2-wv8erc3aRGc4cfQWt3z155',
      'subject' => 'Confirmation instructions',
      'timestamp' => '2017-07-18T08:55:49.389Z',
      'from' => 'noreply@test.com',
      'to' => 'test@mail.com',
      'html' => '<p> Test Email! </p>',
      'text' => 'Test Email!',
      'attachments' => []
    }
  end
  let(:attachment) do
    [{
      'filename' => 'Photos.png',
      'size' => 118_941,
      'contentDisposition' => 'inline',
      'checksum' => 'f5bd3c13cb7b9505796960fff579ca91',
      'contentType' => 'image/jpeg',
      'downloadUrl' => 'https://object.testmail.app/api/20813-5jms2-wv8erc3aRGc4cfQWt3z155/nXCZbtq9FnPd7LyVXoMRmF/Image.jpg'
    }]
  end
  let(:email_object) { Howitzer::Email.adapter.new(message) }

  describe '.find' do
    subject { Howitzer::MailAdapters::Testmail.find(recipient, mail_subject, wait: 0.01) }
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
    it { expect(email_object.plain_text_body).to eql message['text'] }
  end

  describe '#html_body' do
    it { expect(email_object.html_body).to eql message['html'] }
  end

  describe '#text' do
    it { expect(email_object.text).to eql message['text'] }
  end

  describe '#mail_from' do
    it { expect(email_object.mail_from).to eql message['from'] }
  end

  describe '#recipients' do
    subject { email_object.recipients }
    it { is_expected.to be_a_kind_of Array }

    context 'when one recipient' do
      it { is_expected.to include message['to'] }
    end

    context 'when more than one recipient' do
      let(:second_recipient) { 'second_tester@gmail.com' }
      let(:message_with_multiple_recipients) { message.merge('to' => "#{recipient}, #{second_recipient}") }
      let(:email_object) { Howitzer::Email.adapter.new(message_with_multiple_recipients) }
      it { is_expected.to eql [recipient, second_recipient] }
    end
  end

  describe '#received_time' do
    it { expect(email_object.received_time).to eql Time.parse(message['timestamp']).to_s }
  end

  describe '#sender_email' do
    it { expect(email_object.sender_email).to eql message['from'] }
  end

  describe '#mime_part' do
    context 'when has attachments' do
      let(:another_message) { message.merge({ 'attachments' => attachment }) }
      let(:email_object) { Howitzer::Email.adapter.new(another_message) }
      it { expect(email_object.mime_part).not_to be_empty }
    end

    context 'when no attachments' do
      it { expect(email_object.mime_part).to be_empty }
    end
  end

  describe '#mime_part!' do
    context 'when has attachments' do
      let(:another_message) { message.merge('attachments' => attachment) }
      let(:email_object) { Howitzer::Email.adapter.new(another_message) }
      it { expect(email_object.mime_part!).not_to be_empty }
    end

    context 'when no attachments' do
      it do
        expect { email_object.mime_part! }.to raise_error(Howitzer::NoAttachmentsError, 'No attachments were found.')
      end
    end
  end
end
