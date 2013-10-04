require "spec_helper"
require "#{lib_path}/howitzer/utils/log"
require "#{lib_path}/howitzer/utils/email/mail_client"
include LoggerHelper

describe MailClient do

  describe ".default" do
    subject { MailClient.default }
    it do
      expect(log).to receive(:info).with("Connect to default mailbox").once
      expect(subject).to be_instance_of(MailClient)
      options = {
        smtp: {
          address: "smtp.demo.com",
          port: 25,
          domain: "demo.com",
          user_name: "test_user",
          password: "mypass",
          authentication: "plain",
          enable_starttls_auto: true
        },
        pop3: {
          address: "pop.demo.com",
          port: 995,
          user_name: "test_user",
          password: "mypass"
        }
      }
      expect(subject.instance_variable_get(:@options)).to eql(options)
    end
  end

  describe ".by_email" do
    subject { MailClient.by_email("vasya@gmail.com") }
    it do
      expect(log).to receive(:info).with("Connect to 'vasya@gmail.com' mailbox").once
      expect(subject).to be_instance_of(MailClient)
      options = {
        smtp: {
            address: "smtp.demo.com",
            port: 25,
            domain: "demo.com",
            user_name: "test_user",
            password: "mypass",
            authentication: "plain",
            enable_starttls_auto: true
        },
        pop3: {
            address: "pop.demo.com",
            port: 995,
            user_name: "vasya@gmail.com",
            password: "mypass"
        }
      }
      expect(subject.instance_variable_get(:@options)).to eql(options)
    end
  end

  describe ".merge_opts" do
    subject { MailClient.merge_opts(*options) }
    context "when default options" do
      let(:expected_option) do
        {
             smtp: {
                 address: "smtp.demo.com",
                 port: 25,
                 domain: "demo.com",
                 user_name: "test_user",
                 password: "mypass",
                 authentication: "plain",
                 enable_starttls_auto: true
             },
             pop3: {
                 address: "pop.demo.com",
                 port: 995,
                 user_name: "test_user",
                 password: "mypass"
             }
         }
      end
      let(:options) { [] }
      it { expect(subject).to eql(expected_option) }
    end
    context "when custom options" do
      let(:options) do
        [{
            smtp: {
                address: 'fake_address',
                port: 1123,
                domain: 'fake_domain',
                user_name: "fake_user_name",
                password: "fake_password",
                authentication: "plain",
                enable_starttls_auto: true
            },
            pop3: {
                address: "fake_address",
                port: 999,
                user_name: "fake_user_name",
                password: "fake_password"
            }
        }]
      end
      it { expect(subject).to eql(options.first)}
    end
  end
  describe "#find_mail"
  describe "#send_mail"
  describe "#empty_inbox" do
    let(:options) do
      {
          pop3: {
              address: "pop.demo.com",
              port: 995,
              user_name: "vasya@gmail.com",
              password: "mypass"
          }
      }
    end
    it do
      expect(log).to receive(:info).with("Connect to 'vasya@gmail.com' mailbox").once
    end
  end

  describe "MailClient" do
    subject { MailClient.new.start }
    let(:options) do
      {
          pop3: {
              address: "pop.demo.com",
              port: 995,
              user_name: "vasya@gmail.com",
              password: "mypass"
          }
      }
    end
    before do
      allow(Net::POP3).to receive(:start).and_return { options }
    end
    it do
      expect(subject).to eq(options)
    end
  end

  describe "constructor"

end