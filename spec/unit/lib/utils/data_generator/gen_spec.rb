require 'spec_helper'
require "#{lib_path}/howitzer/utils/data_generator/gen"

describe "DataGenerator" do
  describe "Gen" do
    describe ".user" do
      subject { DataGenerator::Gen.user(params) }
      before do
        allow(settings).to receive(:def_test_pass) { 'test_pass' }
        allow(settings).to receive(:mailgun_domain) { 'mail.com' }
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
      end
    end
  end
end