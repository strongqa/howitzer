require 'spec_helper'
require 'howitzer/gmail_api/client'

RSpec.describe Howitzer::GmailApi::Client do
  let(:gmail_obj) { described_class.new }
  let(:recipient) { 'test@gmail.com' }
  let(:mail_subject) { 'Confirmation instructions' }

  describe '.new' do
    subject { gmail_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#find_message' do
    let(:mailbox) { double(Gmail::Mailbox) }
    before do
      allow(mailbox).to receive(:emails).with(
        to: recipient, subject: mail_subject
      ) { [Gmail::Message.new('INBOX', 30)] }
      allow(gmail_obj.instance_variable_get(:@client)).to receive(:inbox) { mailbox }
    end
    it do
      expect(gmail_obj.find_message(recipient, mail_subject)).to be_an_instance_of(Gmail::Message)
    end
  end
end
