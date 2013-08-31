require 'spec_helper'
require "#{lib_path}/howitzer/utils/data_generator/gen"

describe "DataGenerator" do
  describe "Gen" do
    describe ".user" do
      subject { DataGenerator::Gen.user(params) }
      before do
        allow(settings).to receive(:def_test_pass) { 'test_pass' }
        allow(settings).to receive(:mail_pop3_domain) { 'mail.com' }
        allow(DataGenerator::Gen).to receive(:serial) { '012345678abcde' }
      end
      context "when params specified" do
        let(:params) { { login: 'alex', password: 'pa$$w0rd', mailbox: 'member@test.com' } }
        it { expect(subject).to be_an_instance_of DataGenerator::Gen::User }
        it { expect(subject.email).to eql 'u012345678abcde@mail.com' }
        it do
          email_nm = subject.instance_variable_get(:@email_name)
          expect(email_nm).to eql 'u012345678abcde'
        end
        it { expect(subject.domain).to eql 'mail.com' }
        it { expect(subject.login).to eql 'alex' }
        it { expect(subject.password).to eql 'pa$$w0rd' }
        it { expect(subject.first_name).to eql 'FirstName012345678abcde' }
        it { expect(subject.last_name).to eql 'LastName012345678abcde' }
        it { expect(subject.mailbox).to eql 'member@test.com' }
      end
      context "with empty params" do
        let(:params) { {} }
        it { expect(subject).to be_an_instance_of DataGenerator::Gen::User }
        it { expect(subject.email).to eql 'u012345678abcde@mail.com' }
        it do
          email_nm = subject.instance_variable_get(:@email_name)
          expect(email_nm).to eql 'u012345678abcde'
        end
        it { expect(subject.domain).to eql 'mail.com' }
        it { expect(subject.login).to eql 'u012345678abcde' }
        it { expect(subject.password).to eql 'test_pass' }
        it { expect(subject.first_name).to eql 'FirstName012345678abcde' }
        it { expect(subject.last_name).to eql 'LastName012345678abcde' }
        it { expect(subject.mailbox).to be_nil }
      end
    end
    describe ".given_user_by_number" do
      subject { DataGenerator::Gen.given_user_by_number(7) }
      before { stub_const("DataGenerator::DataStorage", double) }
      context "when namespace key found" do
        before { expect(DataGenerator::DataStorage).to receive(:extract).with('user', 7) { :namespace_value } }
        it { expect(subject).to eql(:namespace_value) }
      end
      context "when namespace key not found" do
        let(:dat) { :data_store }
        before do
          allow(DataGenerator::Gen).to receive(:user) { dat }
          expect(DataGenerator::DataStorage).to receive(:extract).with('user', 7) { nil }
          allow(DataGenerator::DataStorage).to receive(:store).with('user', 7, dat)
        end
        it { expect(subject).to eql :data_store }
      end
    end
    describe ".serial" do
      subject { DataGenerator::Gen.serial }
      let(:ser) { 1 }
      context "received value should conform to template" do
        let(:ser) { subject }
        it { expect(ser).to match /\d{9}\w{5}/ }
      end
      context "received values should be different" do
        it { expect(subject).to_not eql ser }
      end
    end
    describe ".delete_all_mailboxes" do
      subject { DataGenerator::Gen.delete_all_mailboxes }
      let(:mbox1) { double }
      let(:mbox2) { double }
      before do
        stub_const("DataGenerator::DataStorage", double)
        expect(DataGenerator::DataStorage).to receive(:extract).with('user') { { 1 => mbox1, 2 => mbox2 } }
      end
      it do
        expect(mbox1).to receive(:delete_mailbox).once
        expect(mbox2).to receive(:delete_mailbox).once
        subject
      end
    end
    describe "User" do
      describe "#initialize" do
        subject { DataGenerator::Gen::User.new(params) }
        let(:params) { { email: 'alex.petrenko@mail.com', login: 'alex', password: 'pa$$w0rd',
                         first_name: 'Alexey', last_name: 'Petrenko', mailbox: 'member@test.com' } }
        it { expect(subject).to be_an_instance_of DataGenerator::Gen::User }
        it { expect(subject.email).to eql 'alex.petrenko@mail.com' }
        it do
          email_nm = subject.instance_variable_get(:@email_name)
          expect(email_nm).to eql 'alex.petrenko'
        end
        it { expect(subject.domain).to eql 'mail.com' }
        it { expect(subject.login).to eql 'alex' }
        it { expect(subject.password).to eql 'pa$$w0rd' }
        it { expect(subject.first_name).to eql 'Alexey' }
        it { expect(subject.last_name).to eql 'Petrenko' }
        it { expect(subject.full_name).to eql 'Alexey Petrenko' }
        it { expect(subject.mailbox).to eql 'member@test.com' }
      end
      describe "#create_mailbox" do
        subject { nu_user.create_mailbox }
        let(:nu_user) { DataGenerator::Gen::User.new({ email: 'alex.petrenko@mail.com', mailbox: 'member@test.com' }) }
        before { stub_const('MailClient', double) }
        context "should return User object" do
          before do
            allow(settings).to receive(:mail_pop3_domain) { 'mail.com' }
            expect(MailClient).to receive(:create_mailbox).with('alex.petrenko').once { 'petrenko@test.com' }
          end
          it { expect(subject).to be_an_instance_of DataGenerator::Gen::User }
        end
        context "when mail_pop3_domain settings are equal to @domain" do
          before do
            allow(settings).to receive(:mail_pop3_domain) { 'mail.com' }
            expect(MailClient).to receive(:create_mailbox).with('alex.petrenko').once { 'petrenko@test.com' }
          end
          it do
            subject
            expect(nu_user.mailbox).to eql 'petrenko@test.com'
          end
        end
        context "when mail_pop3_domain settings are not equal to @domain" do
          before { allow(settings).to receive(:mail_pop3_domain) { 'post.com' } }
          it do
            subject
            expect(nu_user.mailbox).to eql 'member@test.com'
          end
        end
      end
      describe "#delete_mailbox" do
        subject { nu_user.delete_mailbox }
        let(:nu_user) { DataGenerator::Gen::User.new({ mailbox: mbox }) }
        before { stub_const('MailClient', double) }
        context "when mailbox spcified" do
          before { expect(MailClient).to receive(:delete_mailbox).with(mbox).once { 'mailbox deleted' } }
          let(:mbox) { 'member@test.com' }
          it { expect(subject).to eql 'mailbox deleted' }
        end
        context "when mailbox not spcified" do
          before { expect(MailClient).to_not receive(:delete_mailbox).with(mbox) }
          let(:mbox) { nil }
          it { expect(subject).to be_nil }
        end
      end
    end
  end
end