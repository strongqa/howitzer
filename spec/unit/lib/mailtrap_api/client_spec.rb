require 'spec_helper'
require 'howitzer/mailtrap_api/client'

RSpec.describe Howitzer::MailtrapApi::Client do
  let(:mailtrap_obj) { described_class.new }
  let(:recipient) { 'test@mail.com' }
  let(:mail_subject) { 'Confirmation instructions' }
  let(:message) do
    '[{"id": 475265146,
      "inbox_id": 777777,
      "subject": "Confirmation instructions",
      "sent_at": "2017-07-18T08:55:49.389Z",
      "from_email": "noreply@test.com",
      "from_name": "",
      "to_email": "test@mail.com",
      "to_name": "",
      "html_body": "<p> Test Email! </p>"}]'
  end
  let(:message_body) do
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
    "content_type": "image/png"
     }]'
  end

  before do
    allow(Howitzer).to receive(:mailtrap_inbox_id) { 777_777 }
    allow(Howitzer).to receive(:mailtrap_api_token) { 'fake_api_token' }
    stub_const('Howitzer::MailtrapApi::Client::BASE_URL', 'https://mailtrap.io/api/v1/inboxes/777777')
  end

  describe '.new' do
    subject { mailtrap_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#find_message' do
    before do
      FakeWeb.register_uri(:get, "https://mailtrap.io/api/v1/inboxes/#{Howitzer.mailtrap_inbox_id}/" \
                                 "messages?search=#{recipient}", body: message.to_s)
    end
    subject { described_class.new.find_message(recipient, mail_subject) }
    it do
      expect(subject['to_email']).to eql(recipient)
      expect(subject['subject']).to eql(mail_subject)
    end
  end

  describe '#find_attachements' do
    before do
      FakeWeb.register_uri(:get, "https://mailtrap.io/api/v1/inboxes/#{Howitzer.mailtrap_inbox_id}/" \
                                 "messages?search=#{recipient}", body: message.to_s)
      FakeWeb.register_uri(:get, "https://mailtrap.io/api/v1/inboxes/#{Howitzer.mailtrap_inbox_id}/" \
                                 'messages/475265146/attachments', body: attachment.to_s)
    end
    let(:found_message) { described_class.new.find_message(recipient, mail_subject) }
    subject { described_class.new.find_attachments(found_message) }
    it do
      subject.each do |attachment|
        expect(attachment['message_id']).to eql found_message['id']
        expect(attachment['filename'].to_s).not_to be_empty
      end
    end
  end

  # rubocop:disable Layout/LineEndStringConcatenationIndentation
  describe '#get_html_body' do
    let(:response_raw) { double }
    before do
      FakeWeb.register_uri(:get, 'https://mailtrap.io/api/v1/inboxes/' \
                             "#{Howitzer.mailtrap_inbox_id}/messages/475265146/body.html", body: '<p> Test Email! </p>')
    end
    subject { mailtrap_obj.get_html_body(message_body) }
    context 'when success request' do
      it { expect(subject).to eq('<p> Test Email! </p>') }
    end
    context 'when error happens' do
      before do
        allow(RestClient::Resource).to receive(:new).with(any_args).and_return(response_raw)
        mailtrap_obj
        allow(RestClient::Request).to receive(:execute).with(any_args).and_raise(StandardError, 'Some message')
      end
      it { expect { subject }.to raise_error(Howitzer::CommunicationError, 'Some message') }
    end
  end

  describe '#get_txt_body' do
    let(:response_raw) { double }
    before do
      FakeWeb.register_uri(:get, 'https://mailtrap.io/api/v1/inboxes/' \
                                  "#{Howitzer.mailtrap_inbox_id}/messages/475265146/body.txt", body: 'Test Email!')
    end
    subject { mailtrap_obj.get_txt_body(message_body) }
    context 'when success request' do
      it { expect(subject).to eq('Test Email!') }
    end
    context 'when error happens' do
      before do
        allow(RestClient::Resource).to receive(:new).with(any_args).and_return(response_raw)
        mailtrap_obj
        allow(RestClient::Request).to receive(:execute).with(any_args).and_raise(StandardError, 'Some message')
      end
      it { expect { subject }.to raise_error(Howitzer::CommunicationError, 'Some message') }
    end
  end

  describe '#get_raw_body' do
    let(:response_raw) { double }
    before do
      FakeWeb.register_uri(:get, 'https://mailtrap.io/api/v1/inboxes/' \
                              "#{Howitzer.mailtrap_inbox_id}/messages/475265146/body.raw", body: '<p> Test Email! </p>')
    end
    subject { mailtrap_obj.get_raw_body(message_body) }
    context 'when success request' do
      it { expect(subject).to eq('<p> Test Email! </p>') }
    end
    context 'when error happens' do
      before do
        allow(RestClient::Resource).to receive(:new).with(any_args).and_return(response_raw)
        mailtrap_obj
        allow(RestClient::Request).to receive(:execute).with(any_args).and_raise(StandardError, 'Some message')
      end
      it { expect { subject }.to raise_error(Howitzer::CommunicationError, 'Some message') }
    end
  end
  # rubocop:enable Layout/LineEndStringConcatenationIndentation
end
