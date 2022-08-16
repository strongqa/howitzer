require 'spec_helper'
require 'howitzer/onesecmail_api/client'

RSpec.describe Howitzer::OnesecmailApi::Client do
  let(:onesecmail_obj) { described_class.new }
  let(:recipient) { 'test@mail.com' }
  let(:mail_subject) { 'Confirmation instructions' }
  let(:message) do
    '{
      "id": 1,
      "from": "noreply@test.com",
      "subject": "Confirmation instructions",
      "date": "2022-08-16 10:29:41",
      "attachments": [],
      "body": "<p> Test Email! </p>",
      "htmlBody": "<p> Test Email! </p>",
      "textBody": "Test Email!"
    }'
  end

  before do
    allow(Howitzer).to receive(:onesecmail_domain) { '1secmail.com' }
    stub_const(
      'Howitzer::TestmailApi::Client::BASE_URL',
      'https://www.1secmail.com/api/v1/'
    )
  end

  describe '.new' do
    subject { onesecmail_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#find_message' do
    before do
      FakeWeb.register_uri(
        :get,
        "https://www.1secmail.com/api/v1/?action=getMessages&login=#{recipient[/[^@]+/]}" \
        "&domain=#{Howitzer.onesecmail_domain}",
        body: '[{"id":1,"subject":"Confirmation instructions"}]'
      )
      FakeWeb.register_uri(
        :get,
        "https://www.1secmail.com/api/v1/?action=readMessage&login=#{recipient[/[^@]+/]}" \
        "&domain=#{Howitzer.onesecmail_domain}&id=1",
        body: message
      )
    end
    subject { described_class.new.find_message(recipient, mail_subject) }
    it do
      expect(subject['subject']).to eql(mail_subject)
    end
  end
end
