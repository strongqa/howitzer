require "spec_helper"
require_relative "../../../../howitzer/lib/howitzer/utils/logger"
require_relative "../../../lib/howitzer/utils/email/email"

describe Email do
  let(:message) { double }
  let(:message_subject) { 'test_subject' }
  let(:mail_address) { double }
  let(:recipient) { 'vasya@test.com' }
  let(:email_object) { Email.new(message) }
  before do
    Email.const_set("SUBJECT", 'test_subject')
    stub_const("::Mail::Address", mail_address)
    allow(mail_address).to receive(:new).with(recipient).and_return(mail_address)
    allow(message).to receive(:to).and_return([recipient])
  end

  describe "#new" do
    subject { Email.new(message) }
    before { allow(message).to receive(:subject).and_return('test_subject') }
    context "when subject is the same" do
      it { expect(subject.instance_variable_get(:@recipient_address)).to eql(mail_address) }
      it { expect(subject.instance_variable_get(:@message)).to eql(message) } #mock
    end
  end

  describe ".find_by_recipient" do
    subject { Email.find_by_recipient(recipient) }
    context "when 'recipient' specified " do
    before do
      expect(Email).to receive(:find).with(recipient, 'test_subject').and_return(true).once
    end
    it { expect(subject).to be_true }
    end
    context "when 'recipient' not specified " do
      let(:recipient) { nil }
      before do
      expect(Email).to receive(:find).with(recipient,'test_subject').and_return(nil).once
      end
      it { expect(subject).to be_nil }
    end
  end

  describe ".find" do
    let(:mail_client) { double }
    subject { Email.find('Vasya', 'Text') }
      before  do
        stub_const("MailClient", double)
        allow(MailClient).to receive(:by_email).and_return(mail_client)
        allow(mail_client).to receive(:find_mail).and_return(messages )
        allow(message).to receive(:subject).and_return('test_subject')
      end
      context "when messages.first present"  do
        let(:messages) { [message] }
        it {expect(subject).to be_kind_of(Email) }
      end

      context "when messages.first not present" do
        let(:messages) {[]}
        it do
        expect(log).to receive(:error).with("Email was not found (recipient: 'Vasya')").once
        subject
        end
      end
  end

  describe "#plain_text_body" do
    subject { email_object.plain_text_body }
    let(:email_object) { Email.new(message) }
    let(:mime_part) { double }
    before do
      allow(message).to receive(:subject).and_return('test_subject')
      expect(mime_part).to receive(:to_s).and_return('test_string')
      expect(email_object).to receive(:get_mime_part).with(message, 'text/plain').and_return(mime_part)
    end
    it { expect(subject).to eql('test_string') }
  end
end