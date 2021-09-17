require 'spec_helper'
require 'howitzer/gmail_api/client'

RSpec.describe Howitzer::GmailApi::Client do
  let(:gmail_obj) { described_class.new }
  let(:recipient) { 'test@gmail.com' }
  let(:mail_subject) { 'Confirmation instructions' }

  describe 'Loading client' do
    context 'when gmail gem is not installed' do
      before do
        allow(Howitzer::GmailApi::Client).to receive(:require).with(any_args).and_call_original
        allow(Howitzer::GmailApi::Client).to receive(:require).with('gmail').and_raise(LoadError)
      end

      it do
        expect { Howitzer::GmailApi::Client.load_gmail_gem! }.to raise_error(
          LoadError,
          "Unable to load `gmail` library, please add following code to your Gemfile:\n\ngem 'gmail'"
        )
      end
    end
  end

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
