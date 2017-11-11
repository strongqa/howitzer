require 'spec_helper'
require 'howitzer/email'
require 'howitzer/log'
require 'howitzer/exceptions'
RSpec.describe 'Gmail Email Adapter' do
  before do
    allow(Howitzer).to receive(:mail_adapter) { 'gmail' }
    Howitzer::Email.adapter = 'gmail'
  end
  let(:email) { 'test@gmail.com' }
  let(:mail_subject) { 'Confirmation instructions' }
  let(:message) { double(Gmail::Message) }
  let(:email_object) { Howitzer::Email.adapter.new(message) }
  let(:client) { instance_double(Howitzer::GmailApi::Client) }
  let(:to_msg) { { 'name' => 'test', 'route' => nil, 'mailbox' => 'test', 'host' => 'gmail.com' } }
  let(:attachment) do
    '--f403043c3de80c1017055511c33d
Content-Type: text/plain; charset="US-ASCII"; name="te.txt"
Content-Disposition: attachment; filename="te.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j5iaurws0'
  end
  before do
    allow_any_instance_of(Howitzer::GmailApi::Client).to receive(:find_message).with(
      email,
      mail_subject
    ) { message }
    allow_any_instance_of(Howitzer::GmailApi::Client).to receive(:find_message).with(
      email,
      'Wrong subject'
    ) { nil }
  end
  describe '.find' do
    subject { Howitzer::MailAdapters::Gmail.find(email, mail_subject, wait: 0.01) }
    context 'when message is found' do
      it do
        expect(Howitzer::Email.adapter).to receive(:new).with(message).once
        subject
      end
    end

    context 'when message is not found' do
      let(:mail_subject) { 'Wrong subject' }
      it do
        expect { subject }.to raise_error(
          Howitzer::EmailNotFoundError,
          "Message with subject '#{mail_subject}' for recipient '#{email}' was not found."
        )
      end
    end
  end

  describe '#plain_text_body' do
    before { allow(message).to receive(:body) { Mail::Body.new('test body') } }
    it { expect(email_object.plain_text_body).to eql 'test body' }
  end

  describe '#html_body' do
    before do
      html_part = <<-HTML
      Content-Type: text/html;
        charset=UTF-8
      Content-Transfer-Encoding: 7bit
      <p>test body</p>
      HTML
      allow(message).to receive(:html_part) { Mail::Part.new(html_part) }
    end
    it { expect(email_object.html_body).to include('<p>test body</p>') }
  end

  describe '#text' do
    before { allow(message).to receive(:text_part) { Mail::Part.new('test text part') } }
    it { expect(email_object.text).to include 'test text part' }
  end

  describe '#mail_from' do
    before { allow(message).to receive(:from) { [to_msg] } }
    it { expect(email_object.mail_from).to eql email }
  end

  describe '#recipients' do
    context 'when one recipient' do
      before { allow(message).to receive(:to) { [to_msg] } }
      it { expect(email_object.recipients).to include email }
    end
    context 'when several recipients' do
      before { allow(message).to receive(:to) { [to_msg, to_msg.merge('mailbox' => 'test2')] } }
      it { expect(email_object.recipients).to eql [email, 'test2@gmail.com'] }
    end
  end

  describe '#received_time' do
    before { allow(message).to receive(:date) { 'Mon, 24 Jul 2017 18:20:58 +0300' } }
    it { expect(email_object.received_time).to eql Time.parse('Mon, 24 Jul 2017 18:20:58 +0300').strftime('%F %T') }
  end

  describe '#sender_email' do
    before { allow(message).to receive(:from) { [to_msg] } }
    it { expect(email_object.mail_from).to eql email }
  end

  describe '#mime_part' do
    before { allow(message).to receive(:attachments) { Mail::AttachmentsList.new([Mail::Part.new(attachment)]) } }
    context 'when has attachments'
    it { expect(email_object.mime_part).not_to be_empty }

    context 'when no attachments' do
      it do
        allow(message).to receive(:attachments) { [] }
        expect(email_object.mime_part).to be_empty
      end
    end
  end

  describe '#mime_part!' do
    before { allow(message).to receive(:attachments) { Mail::AttachmentsList.new([Mail::Part.new(attachment)]) } }
    context 'when has attachments' do
      it { expect(email_object.mime_part!).not_to be_empty }
    end

    context 'when no attachments' do
      it do
        allow(message).to receive(:attachments) { [] }
        expect { email_object.mime_part! }.to raise_error(Howitzer::NoAttachmentsError, 'No attachments were found.')
      end
    end
  end
end
