require 'spec_helper'
require_relative '../../../lib/howitzer/utils/data_generator/data_storage'

describe "DataGenerator" do
  describe "DataStorage" do
    describe ".store" do
      subject { DataGenerator::DataStorage.store(ns, 7, :halt) }
      context "when namespace specified" do
        let(:ns) { :user }
        it "should return value" do
          expect(subject).to eql(:halt)
        end
        it "should store namespace value" do
          adata = DataGenerator::DataStorage.instance_variable_get(:@data)
          expect(adata[:user]).to eql({7 => :halt})
        end
      end
      context "when namespace empty" do
        let(:ns) { nil }
        it { expect {subject}.to raise_error(RuntimeError, "Data storage namespace can not be empty") }
      end
    end
    describe ".extract" do
      subject { DataGenerator::DataStorage.extract(ns, key) }
      before { DataGenerator::DataStorage.instance_variable_set(:@data, {user: {7 => :exit}}) }
      describe "when namespace specified" do
        let(:ns) { :user }
        context "and namespace key found" do
          let(:key) { 7 }
          it { expect(subject).to eql(:exit) }
        end
        context "and namespace key not found" do
          let(:key) { 5 }
          it { expect(subject).to be_nil }
        end
        context "but namespace key not specified" do
          let(:key) { nil }
          it { expect(subject).to eql({ 7 => :exit }) }
        end
      end
      context "when namespace not found" do
        let(:ns) { :guest }
        let(:key) { 11 }
        it { expect(subject).to be_nil }
      end
      context "when namespace not specified" do
        let(:ns) { nil }
        let(:key) { nil }
        it { expect {subject}.to raise_error(RuntimeError, "Data storage namespace can not be empty") }
      end
    end
    describe ".clear_ns" do
      subject { DataGenerator::DataStorage.clear_ns(:user) }
      before { DataGenerator::DataStorage.instance_variable_set(:@data, {user: {7 => :exit}}) }
      it "should return empty hash" do
        subject
        adata = DataGenerator::DataStorage.instance_variable_get(:@data)
        expect(adata[:user]).to eql({})
      end
    end
  end
end