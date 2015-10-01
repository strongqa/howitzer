require 'spec_helper'
require 'howitzer/email'
require 'howitzer/utils/log'
require 'howitzer/exceptions'

RSpec.describe 'Email' do
  let(:recipient){ 'first_tester@gmail.com' }
  let(:message_subject){ 'test subject' }

  before do
    stub_const('Email::SUBJECT', message_subject)
  end

  describe '.adapter' do
    it { expect(Email.adapter).to eql ::MailAdapters.const_get(settings.mail_adapter.to_s.capitalize)}
  end

  describe '.adapter_name' do
    it { expect(Email.adapter_name).to eql settings.mail_adapter.to_sym}
  end

  describe '.adapter=' do
    subject {Email.adapter = name}

    context 'when adapter_name is Symbol or String' do
      let(:name) {settings.mail_adapter}
      it { expect(Email.adapter).to eql ::MailAdapters.const_get(settings.mail_adapter.to_s.capitalize)}
    end

    context 'when adapter_name is not Symbol or String' do
      let(:name) {nil}
      it { expect { subject }.to raise_error(Howitzer::NoMailAdapterError)}
    end
  end

  describe '.find_by_recipient' do
    let(:recipient) { 'test@user.com' }
    subject { Email.find_by_recipient(recipient) }
    it do
      expect(Email).to receive(:find).with(recipient, message_subject).once
      subject
    end
  end

  describe '.find' do
    let(:recipient) { 'test@user.com' }
    subject { Email.find(recipient, message_subject) }
    it do
      expect(Email.adapter).to receive(:find).with(recipient, message_subject).once
      subject
    end
  end

end