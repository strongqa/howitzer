require 'spec_helper'
require 'howitzer/email'
require 'howitzer/utils/log'
require 'howitzer/exceptions'
require 'howitzer/mailgun/connector'

RSpec.describe 'Mailgun Email Adapter' do
  let(:recipient){ 'first_tester@gmail.com' }
  let(:message) do
    {
        'body-plain' => 'test body footer',
        'stripped-html' => '<p> test body </p> <p> footer </p>',
        'stripped-text' => 'test body',
        'From' => 'Strong Tester <tester@gmail.com>',
        'To' => recipient,
        'Received' => 'by 10.216.46.75 with HTTP; Sat, 5 Apr 2014 05:10:42 -0700 (PDT)',
        'sender' => 'tester@gmail.com',
        'attachments' => []
    }
  end
  let(:message_subject){ 'test subject' }
  let(:mail_address){ double }
  let(:email_object){ Email.adapter.new(message) }

  before do
    stub_const('Email::SUBJECT', message_subject)
  end

  describe '.find' do
    let(:mailgun_message){ double(to_h: message) }
    let(:events) { double(to_h: {'items' => [event]}) }
    subject { Email.find(recipient, message_subject) }

    context 'when message is found' do
      let(:event) { {'message' => {'recipients' => [recipient], 'headers' => {'subject' => message_subject} }, 'storage' => {'key' => '1234567890'} } }
      before do
        allow(::Mailgun::Connector.instance.client).to receive(:get).with('mailgun@test.domain/events', event: 'stored').ordered.once {events}
        allow(::Mailgun::Connector.instance.client).to receive(:get).with('domains/mailgun@test.domain/messages/1234567890').ordered.once { mailgun_message }
      end
      it do
        expect(Email.adapter).to receive(:new).with(message).once
        subject
      end
    end

    context 'when message is not found' do
      let(:event) { {'message' => {'recipients' => ['other@test.com'], 'headers' => {'subject' => message_subject} }, 'storage' => {'key' => '1234567890'} } }
      before do
        allow(settings).to receive(:timeout_small) { 0.5 }
        allow(settings).to receive(:timeout_short) { 0.05 }
        allow(::Mailgun::Connector.instance.client).to receive(:get).with('mailgun@test.domain/events', event: 'stored').at_least(:twice).ordered {events}
      end
      it do
        expect(log).to receive(:error).with(Howitzer::EmailNotFoundError, "Message with subject '#{message_subject}' for recipient '#{recipient}' was not found.")
        subject
      end
    end
  end

  describe '#plain_text_body' do
    it { expect(email_object.plain_text_body).to eql message['body-plain'] }
  end

  describe '#html_body' do
    it { expect(email_object.html_body).to eql message['stripped-html'] }
  end

  describe '#text' do
    it { expect(email_object.text).to eql message['stripped-text'] }
  end

  describe '#mail_from' do
    it { expect(email_object.mail_from).to eql message['From'] }
  end

  describe '#recipients' do
    subject { email_object.recipients }
    it { is_expected.to be_a_kind_of Array }

    context 'when one recipient' do
      it { is_expected.to include message['To']}
    end

    context 'when more than one recipient' do
      let(:second_recipient) { 'second_tester@gmail.com' }
      let(:message_with_multiple_recipients) { message.merge({'To' => "#{recipient}, #{second_recipient}"}) }
      let(:email_object) { Email.adapter.new(message_with_multiple_recipients) }
      it { is_expected.to eql [recipient, second_recipient] }
    end
  end

  describe '#received_time' do
    it { expect(email_object.received_time).to eql message['Received'][27..63] }
  end

  describe '#sender_email' do
    it { expect(email_object.sender_email).to eql message['sender'] }
  end

  describe '#get_mime_part' do
    subject { email_object.get_mime_part }

    context 'when has attachments' do
      let(:files) { [double] }
      before { email_object.instance_variable_set(:@message, 'attachments' => files)}
      it { is_expected.to eq(files) }
    end

    context 'when no attachments' do
      let(:error) { Howitzer::NoAttachmentsError }
      let(:error_message) { 'No attachments where found.' }
      it do
        expect(log).to receive(:error).with(error, error_message).once
        subject
      end
    end
  end

end