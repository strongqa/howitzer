require 'spec_helper'
require_relative '../../../lib/howitzer/utils/email/mailgun_helper'

describe MailgunHelper do
  let(:mailgun) { double.extend MailgunHelper }
  let(:user_name) { 'vasyapupkin' }
  let(:settings_obj) { double }
  let(:mbox) { double }
  before do
    stub_const('Mailbox', double)
  end
  describe "#create_mailbox" do
    subject { mailgun.create_mailbox(user_name, *opts) }
    before do
      expect(log).to receive(:info).with(log_message).once
      allow(Mailbox).to receive(:new).and_return(mbox)
      expect(mbox).to receive(:upsert).once
    end
    context "when domain and password are present" do
      let(:log_message) { "Create 'vasyapupkin@mail.ru' mailbox" }
      let(:opts) { ['mail.ru', '123'] }
      it { expect(subject).to eql(mbox) }
    end
    context "when domain and password are missed" do
      let(:opts) { [] }
      let(:log_message) { "Create 'vasyapupkin@test.com' mailbox" }
      before do
        allow(mailgun).to receive(:settings).and_return(settings_obj)
        allow(settings_obj).to receive(:mail_pop3_domain).and_return('test.com')
        allow(settings_obj).to receive(:mail_pop3_user_pass).and_return('test123')
      end
      it { expect(subject).to eql(mbox) }
    end
  end

  describe "#delete_mailbox" do
    subject{ mailgun.delete_mailbox(mbox)}
    before do
      allow(mbox).to receive(:user).and_return('vasyapupkin')
      allow(mbox).to receive(:domain).and_return('mail.ru')
      expect(log).to receive(:info).with("Delete 'vasyapupkin@mail.ru' mailbox").once
    end
    context "when successful result" do
      before {expect(Mailbox).to receive(:remove).with(mbox).and_return(true)}
      it { expect(subject).to be_true }
    end
    context "when impossible to remove mailbox" do
      before {expect(Mailbox).to receive(:remove).with(mbox).and_raise('Test error message')}
      it do
        expect(log).to receive(:warn).with("Unable to delete 'vasyapupkin' mailbox: Test error message")
        subject
      end
    end
  end

  describe "#delete_all_mailboxes" do
    let(:domain) { 'mail.ru' }
    let(:mailbox1) do
      m = double
      allow(m).to receive(:id).and_return(1)
      allow(m).to receive(:user).and_return('vasyapupkin')
      allow(m).to receive(:domain).and_return(domain)
      m
    end
    let(:mailbox2) do
      m = double
      allow(m).to receive(:id).and_return(2)
      allow(m).to receive(:user).and_return('postmaster')
      allow(m).to receive(:domain).and_return(domain)
      m
    end
    let(:mailbox3) do
      m = double
      allow(m).to receive(:id).and_return(3)
      allow(m).to receive(:user).and_return('admin')
      allow(m).to receive(:domain).and_return(domain)
      m
    end
    let(:mail_for_exception){ 'admin@mail.ru' }
    subject{mailgun.delete_all_mailboxes(mail_for_exception)}
    before do
      allow(settings).to receive(:mail_smtp_domain).and_return("mail.ru")
      allow(Mailbox).to receive(:find).with(:all).and_return([mailbox1, mailbox2, mailbox3])
    end
    it do
      expect(log).to receive(:info).with("Delete all mailboxes except: \"admin@mail.ru\", \"postmaster@mail.ru\"")
      expect(Mailbox).to receive(:delete).with(1).once
      expect(Mailbox).to_not receive(:delete).with(2)
      expect(Mailbox).to_not receive(:delete).with(3)
      expect(log).to receive(:info).with("Were deleted '1' mailboxes")
      subject
    end
  end
end
#
#module MailgunHelper
#
#  def delete_all_mailboxes(*exceptions)
#    puts exceptions.inspect
#    exceptions += %w"postmaster@#{settings.mail_smtp_domain}" #system and default mailbox
#    exceptions = exceptions.uniq
#    log.info "Delete all mailboxes #{"except: " + exceptions.inspect unless exceptions.empty?}"
#    i = 0
#    Mailbox.find(:all).each do |m|
#      next if exceptions.include?("#{m.user}@#{m.domain}")
#      Mailbox.delete(m.id)
#      i += 1
#    end
#
#    log.info "Were deleted '#{i}' mailboxes"
#  end
#end