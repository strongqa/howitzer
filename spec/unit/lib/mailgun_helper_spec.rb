require 'spec_helper'
require_relative '../../../lib/howitzer/utils/email/mailgun_helper'

describe MailgunHelper do
  describe "#create_mailbox" do
    let(:mailgun) { double.extend MailgunHelper }
    let(:user_name) { 'vasyapupkin' }
    let(:log_obj) { double }
    let(:settings_obj) { double }
    let(:mbox) { double }
    subject { mailgun.create_mailbox(user_name, *opts) }
    before do
      stub_const('Mailbox', double)
      allow(mailgun).to receive(:log).and_return(log_obj)
      expect(log_obj).to receive(:info).with(log_message)
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

  end
end



#module MailgunHelper
#
#  def create_mailbox(user_name,
#      domain=settings.mail_pop3_domain,
#      password=settings.mail_pop3_user_pass)
#    log.info "Create '#{user_name}@#{domain}' mailbox"
#    mbox = Mailbox.new(:user => user_name, :domain => domain, :password => password)
#    mbox.upsert()
#    mbox
#  end
#
#  def delete_mailbox(mailbox)
#    log.info "Delete '#{mailbox.user}@#{mailbox.domain}' mailbox"
#    begin
#      Mailbox.remove(mailbox)
#    rescue Exception => e
#      log.warn "Unable to delete '#{mailbox.user}' mailbox: #{e.message}"
#    end
#  end
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