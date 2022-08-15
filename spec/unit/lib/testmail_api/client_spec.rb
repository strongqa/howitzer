require 'spec_helper'
require 'howitzer/testmail_api/client'

RSpec.describe Howitzer::TestmailApi::Client do
  let(:testmail_obj) { described_class.new }
  let(:recipient) { 'test@mail.com' }
  let(:mail_subject) { 'Confirmation instructions' }
  let(:message) do
    '{
      "result": "success",
      "message": null,
      "count": 1,
      "limit": 10,
      "offset": 0,
      "emails": [
        {
          "id": "20813-5jms2-wv8erc3aRGc4cfQWt3z155",
          "subject": "Confirmation instructions",
          "timestamp": 1660150266119,
          "from": "noreply@test.com",
          "to": "test@mail.com",
          "html": "<p> Test Email! </p>",
          "text": "Test Email!",
          "attachments": []
        }
      ]
    }'
  end

  before do
    allow(Howitzer).to receive(:testmail_api_key) { 'api_key' }
    allow(Howitzer).to receive(:testmail_namespace) { 'namespace' }
    stub_const(
      'Howitzer::TestmailApi::Client::BASE_URL',
      'https://api.testmail.app/api/json?apikey=api_key&namespace=namespace'
    )
  end

  describe '.new' do
    subject { testmail_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#find_message' do
    before do
      FakeWeb.register_uri(:get, "https://api.testmail.app/api/json?apikey=#{Howitzer.testmail_api_key}" \
                                 "&namespace=#{Howitzer.testmail_namespace}" \
                                 "&tag=#{recipient}", body: message.to_s)
    end
    subject { described_class.new.find_message(recipient, mail_subject) }
    it do
      expect(subject['to']).to eql(recipient)
      expect(subject['subject']).to eql(mail_subject)
    end
  end
end
