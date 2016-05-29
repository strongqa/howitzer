require 'spec_helper'
require 'howitzer/email'
require 'howitzer/utils/log'
require 'howitzer/exceptions'

RSpec.describe Howitzer::Email do
  let(:recipient) { 'first_tester@gmail.com' }
  let(:message_subject) { 'test subject' }
  let(:message) { double(:message) }
  let(:email_object) { described_class.new(message) }

  before do
    stub_const('Howitzer::Email::SUBJECT', message_subject)
  end

  describe '.adapter' do
    it { expect(described_class.adapter).to eql Howitzer::MailAdapters.const_get(settings.mail_adapter.to_s.capitalize) }
  end

  describe '.adapter_name' do
    it { expect(described_class.adapter_name).to eql settings.mail_adapter.to_sym }
  end

  describe '.adapter=' do
    subject { described_class.adapter = name }

    context 'when adapter_name is Symbol or String' do
      let(:name) { settings.mail_adapter }
      it { expect(described_class.adapter).to eql Howitzer::MailAdapters.const_get(name.to_s.capitalize) }
    end

    context 'when adapter_name is not Symbol or String' do
      let(:name) { nil }
      it { expect { subject }.to raise_error(Howitzer::NoMailAdapterError) }
    end
  end

  describe '.find_by_recipient' do
    let(:recipient) { 'test@user.com' }
    subject { described_class.find_by_recipient(recipient) }
    it do
      expect(described_class).to receive(:find).with(recipient, message_subject).once
      subject
    end
  end

  describe '.find' do
    let(:recipient) { 'test@user.com' }
    subject { described_class.find(recipient, message_subject) }
    it do
      expect(described_class.adapter).to receive(:find).with(recipient, message_subject).once
      subject
    end
  end

  describe '#new' do
    context 'when Email instance receive message and add create @message variable that' do
      it { expect(email_object.instance_variable_get(:@message)).to eql message }
    end
  end

  describe '#plain_text_body' do
    subject { email_object.plain_text_body }
    it do
      expect(message).to receive(:plain_text_body).once
      subject
    end
  end

  describe '#html_body' do
    subject { email_object.html_body }
    it do
      expect(message).to receive(:html_body).once
      subject
    end
  end

  describe '#text' do
    subject { email_object.text }
    it do
      expect(message).to receive(:text).once
      subject
    end
  end

  describe '#mail_from' do
    subject { email_object.mail_from }
    it do
      expect(message).to receive(:mail_from).once
      subject
    end
  end

  describe '#recipients' do
    subject { email_object.recipients }
    it do
      expect(message).to receive(:recipients).once
      subject
    end
  end

  describe '#received_time' do
    subject { email_object.received_time }
    it do
      expect(message).to receive(:received_time).once
      subject
    end
  end

  describe '#sender_email' do
    subject { email_object.sender_email }
    it do
      expect(message).to receive(:sender_email).once
      subject
    end
  end

  describe '#mime_part' do
    subject { email_object.mime_part }
    it do
      expect(message).to receive(:mime_part).once
      subject
    end
  end
end
