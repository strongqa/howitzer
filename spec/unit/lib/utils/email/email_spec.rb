require "spec_helper"
require "#{lib_path}/howitzer/utils/log"
require "#{lib_path}/howitzer/utils/email/email"


describe Email do
  pending("Need to rewrite")
  let(:message) { double }
  let(:message_subject) { 'test_subject' }
  let(:mail_address) { double }
  let(:recipient) { 'vasya@test.com' }
  let(:email_object) { Email.new(message) }
  before do
    stub_const("Email::SUBJECT", 'test_subject')
    stub_const("::Mail::Address", mail_address)
    allow(mail_address).to receive(:new).with(recipient).and_return(mail_address)
    allow(message).to receive(:to).and_return([recipient])
  end

  describe "#new" do
    subject { Email.new(message) }
    before { allow(message).to receive(:subject).and_return('test_subject') }
    context "when subject is the same" do
      it { expect(subject.instance_variable_get(:@recipient_address)).to eql(mail_address) }
      it { expect(subject.instance_variable_get(:@message)).to eql(message) }
    end
  end

  describe ".find_by_recipient" do
    subject { Email.find_by_recipient(recipient) }
    context "when 'recipient' specified " do
      before { expect(Email).to receive(:find).with(recipient, 'test_subject').and_return(true).once }
      it { expect(subject).to be_true }
    end
    context "when 'recipient' not specified " do
      let(:recipient) { nil }
      before { expect(Email).to receive(:find).with(recipient,'test_subject').and_return(nil).once }
      it { expect(subject).to be_nil }
    end
  end

  describe ".find" do
    pending("Implement when .find will be implemented")
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