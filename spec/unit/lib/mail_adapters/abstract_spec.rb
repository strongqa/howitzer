require 'spec_helper'
require 'howitzer/mail_adapters/abstract'

RSpec.describe MailAdapters::Abstract do
  let(:message) { double(:message) }
  let(:abstract_adapter) { described_class.new(message) }
  let(:email_object){ Email.adapter.new(message) }

  describe '#new' do
    context 'when Email instance receive message and add create @message variable that' do
      it { expect(email_object.instance_variable_get(:@message)).to eql message}
    end
  end

  describe '#plain_text_body' do
    subject { abstract_adapter.plain_text_body }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

  describe '#html_body' do
    subject { abstract_adapter.html_body }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

  describe '#text' do
    subject { abstract_adapter.text }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

  describe '#mail_from' do
    subject { abstract_adapter.mail_from }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

  describe '#recipients' do
    subject { abstract_adapter.recipients }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

  describe '#received_time' do
    subject { abstract_adapter.received_time }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

  describe '#sender_email' do
    subject { abstract_adapter.sender_email }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

  describe '#get_mime_part' do
    subject { abstract_adapter.get_mime_part }
    it { expect{subject}.to raise_error(NotImplementedError)}
  end

end
