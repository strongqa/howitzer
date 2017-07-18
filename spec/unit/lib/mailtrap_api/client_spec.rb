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
  let(:attachment) do
    '[{
    "id": 1737,
    "message_id": 475265146,
    "filename": "Photos.png",
    "attachment_type": "attachment",
    "content_type": "image/png"
     }]'
  end
  before { allow(Howitzer).to receive(:inbox_id) { 777_777 } }
  before { allow(Howitzer).to receive(:api_token) { 'fake_api_token' } }

  describe '.new' do
    subject { mailtrap_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#find_message' do
    before do
      FakeWeb.register_uri(:get, "https://mailtrap.io/api/v1/inboxes/#{Howitzer.inbox_id}/"\
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
      FakeWeb.register_uri(:get, "https://mailtrap.io/api/v1/inboxes/#{Howitzer.inbox_id}/"\
                                 "messages?search=#{recipient}", body: message.to_s)
      FakeWeb.register_uri(:get, "https://mailtrap.io/api/v1/inboxes/#{Howitzer.inbox_id}/"\
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
end
