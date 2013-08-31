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
        let(:nu_user) { subject }
        it { expect(nu_user).to be_an_instance_of DataGenerator::Gen::User }
        it { expect(nu_user.email).to eql 'u012345678abcde@mail.com' }
        it do
          email_nm = nu_user.instance_variable_get(:@email_name)
          expect(email_nm).to eql 'u012345678abcde'
        end
        it { expect(nu_user.domain).to eql 'mail.com' }
        it { expect(nu_user.login).to eql 'alex' }
        it { expect(nu_user.password).to eql 'pa$$w0rd' }
        it { expect(nu_user.first_name).to eql 'FirstName012345678abcde' }
        it { expect(nu_user.last_name).to eql 'LastName012345678abcde' }
        it { expect(nu_user.mailbox).to eql 'member@test.com' }
      end
      context "with empty params" do
        let(:params) { {} }
        let(:nu_user) { subject }
        it { expect(nu_user).to be_an_instance_of DataGenerator::Gen::User }
        it { expect(nu_user.email).to eql 'u012345678abcde@mail.com' }
        it do
          email_nm = nu_user.instance_variable_get(:@email_name)
          expect(email_nm).to eql 'u012345678abcde'
        end
        it { expect(nu_user.domain).to eql 'mail.com' }
        it { expect(nu_user.login).to eql 'u012345678abcde' }
        it { expect(nu_user.password).to eql 'test_pass' }
        it { expect(nu_user.first_name).to eql 'FirstName012345678abcde' }
        it { expect(nu_user.last_name).to eql 'LastName012345678abcde' }
        it { expect(nu_user.mailbox).to be_nil }
      end
    end
    describe ".given_user_by_number" do
      subject { DataGenerator::Gen.given_user_by_number(num) }
      let(:num) { 7 }
      let(:data_stor) { double }
      before { stub_const("DataStorage", data_stor) }
      context "when namespace key found" do
        before { expect(data_stor).to receive(:extract).with('user', num.to_i) { :namespace_value } }
        it { expect(subject).to eql(:namespace_value) }
      end
      context "when namespace key not found" do
        let(:dat) { :data_store }
        before do
          allow(DataGenerator::Gen).to receive(:user) { dat }
          expect(data_stor).to receive(:extract).with('user', num.to_i) { nil }
          allow(data_stor).to receive(:store).with('user', num.to_i, dat)
        end
        it { expect(subject).to eql :data_store }
      end
    end
    describe ".serial" do
      subject { DataGenerator::Gen.serial }
      it { expect(subject).to match /\d{9}\w{5}/ }
    end
    describe ".delete_all_mailboxes" do
      subject { DataGenerator::Gen.delete_all_mailboxes }
      let(:data_stor) { double }
      let(:mbox1) { DataGenerator::Gen::User.new }
      let(:mbox2) { DataGenerator::Gen::User.new }
      before do
        stub_const("DataStorage", data_stor)
        expect(data_stor).to receive(:extract).with('user') { { 1 => mbox1, 2 => mbox2 } }
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
        let(:nu_user) { subject }
        it { expect(nu_user).to be_an_instance_of DataGenerator::Gen::User }
        it { expect(nu_user.email).to eql 'alex.petrenko@mail.com' }
        it do
          email_nm = nu_user.instance_variable_get(:@email_name)
          expect(email_nm).to eql 'alex.petrenko'
        end
        it { expect(nu_user.domain).to eql 'mail.com' }
        it { expect(nu_user.login).to eql 'alex' }
        it { expect(nu_user.password).to eql 'pa$$w0rd' }
        it { expect(nu_user.first_name).to eql 'Alexey' }
        it { expect(nu_user.last_name).to eql 'Petrenko' }
        it { expect(nu_user.full_name).to eql 'Alexey Petrenko' }
        it { expect(nu_user.mailbox).to eql 'member@test.com' }
      end
      describe "#create_mailbox" do
        subject { nu_user.create_mailbox }
        let(:nu_user) { DataGenerator::Gen::User.new({ email: 'alex.petrenko@mail.com', mailbox: 'member@test.com' }) }
        before { stub_const('MailClient', double) }
        context "if settings.mail_pop3_domain == @domain" do
          before do
            allow(settings).to receive(:mail_pop3_domain) { 'mail.com' }
            expect(MailClient).to receive(:create_mailbox).with('alex.petrenko').once { 'petrenko@test.com' }
          end
          it do
            subject
            expect(nu_user.mailbox).to eql 'petrenko@test.com'
          end
        end
        context "if settings.mail_pop3_domain != @domain" do
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
          let(:mbox) { nil }
          it { expect(subject).to be_nil }
        end
      end
    end
  end
end