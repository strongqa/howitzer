require 'spec_helper'
require 'howitzer/email'
require 'howitzer/log'
require 'howitzer/exceptions'
RSpec.describe 'Mailtrap Email Adapter' do
  before do
    allow(Howitzer).to receive(:mail_adapter) { 'mailtrap' }
    Howitzer::Email.adapter = 'mailtrap'
    allow(Howitzer).to receive(:mailtrap_inbox_id) { 777_777 }
    allow(Howitzer).to receive(:mailtrap_api_token) { 'fake_api_token' }
    base_url = 'https://mailtrap.io/api/v1/inboxes/777777/messages'
    stub_const('Howitzer::MailtrapApi::Client::BASE_URL', base_url.gsub('/messages', ''))
    FakeWeb.register_uri(:get, "#{base_url}/475265146/attachments", body: attachment.to_s)
    FakeWeb.register_uri(:get, "#{base_url}/32/attachments", body: '[]')
    FakeWeb.register_uri(:get, "#{base_url}?search=#{recipient}", body: "[#{message.to_s.gsub('=>', ':')}]")
  end
  let(:recipient) { 'test@mail.com' }
  let(:mail_subject) { 'Confirmation instructions' }
  let(:message) do
    {
      'id' => 475_265_146,
      'inbox_id' => 777_777,
      'subject' => 'Confirmation instructions',
      'sent_at' => '2017-07-18T08:55:49.389Z',
      'from_email' => 'noreply@test.com',
      'from_name' => '',
      'to_email' => 'test@mail.com',
      'to_name' => '',
      'html_path' => '/api/v1/inboxes/777777/messages/475265146/body.html',
      'txt_path' => '/api/v1/inboxes/777777/messages/475265146/body.txt',
      'raw_path' => '/api/v1/inboxes/777777/messages/475265146/body.raw',
      'created_at' => '2017-07-18T14:14:31.641Z'
    }
  end
  let(:attachment) do
    '[{
    "id": 1737,
    "message_id": 475265146,
    "filename": "Photos.png",
    "attachment_type": "attachment",
    "content_type": "image/png",
    "download_path": "/api/v1/inboxes/777777/messages/475265146/attachments/45120545/download"
     }]'
  end
  let(:email_object) { Howitzer::Email.adapter.new(message) }
  describe '.find' do
    subject { Howitzer::MailAdapters::Mailtrap.find(recipient, mail_subject, wait: 0.01) }
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
    it { expect(email_object.plain_text_body).to eql message['txt_path'] }
  end

  describe '#html_body' do
    it { expect(email_object.html_body).to eql message['html_path'] }
  end

  describe '#text' do
    it { expect(email_object.text).to eql message['raw_path'] }
  end

  describe '#mail_from' do
    it { expect(email_object.mail_from).to eql message['from_email'] }
  end

  describe '#recipients' do
    subject { email_object.recipients }
    it { is_expected.to be_a_kind_of Array }

    context 'when one recipient' do
      it { is_expected.to include message['to_email'] }
    end

    context 'when more than one recipient' do
      let(:second_recipient) { 'second_tester@gmail.com' }
      let(:message_with_multiple_recipients) { message.merge('to_email' => "#{recipient}, #{second_recipient}") }
      let(:email_object) { Howitzer::Email.adapter.new(message_with_multiple_recipients) }
      it { is_expected.to eql [recipient, second_recipient] }
    end
  end

  describe '#received_time' do
    it { expect(email_object.received_time).to eql Time.parse(message['created_at']).to_s }
  end

  describe '#sender_email' do
    it { expect(email_object.sender_email).to eql message['from_email'] }
  end

  describe '#mime_part' do
    context 'when has attachments' do
      it { expect(email_object.mime_part).not_to be_empty }
    end

    context 'when no attachments' do
      let(:another_message) { message.merge('id' => 32) }
      let(:email_object) { Howitzer::Email.adapter.new(another_message) }
      it { expect(email_object.mime_part).to be_empty }
    end
  end

  describe '#mime_part!' do
    context 'when has attachments' do
      it { expect(email_object.mime_part!).not_to be_empty }
    end

    context 'when no attachments' do
      let(:another_message) { message.merge('id' => 32) }
      let(:email_object) { Howitzer::Email.adapter.new(another_message) }
      it do
        expect { email_object.mime_part! }.to raise_error(Howitzer::NoAttachmentsError, 'No attachments were found.')
      end
    end
  end
end
