require 'spec_helper'
require_relative '../../../lib/howitzer/utils/data_generator/data_storage'

describe "DataGenerator" do
  describe "DataStorage" do
    describe "#store" do
      subject { DataGenerator::DataStorage.store(ns, 7, :halt) }
      context "when namespace specified" do
        let(:ns) { :user }
        it do
          expect(subject).to eql(:halt)
          adata = DataGenerator::DataStorage.instance_variable_get(:@data)
          expect(adata[:user]).to eql({7 => :halt})
        end
      end
      context "when namespace empty" do
        let(:ns) { nil }
        it { expect {subject}.to raise_error(RuntimeError, "Data storage namespace can not be empty") }
      end
    end
    describe "#extract" do
      subject { DataGenerator::DataStorage.extract(:user, key) }
      before { DataGenerator::DataStorage.instance_variable_set(:@data, {user: {7 => :exit}}) }
      context "when namespace key found" do
        let(:key) { 7 }
        it { expect(subject).to eql(:exit) }
      end
      context "when namespace key not found" do
        let(:key) { 5 }
        it { expect(subject).to eql(nil) }
      end
      context "when namespace key not specified" do
        let(:key) { nil }
        it { expect(subject).to eql({ 7 => :exit }) }
      end
    end
    describe "#clear_ns" do
      subject { DataGenerator::DataStorage.clear_ns(:user) }
      before { DataGenerator::DataStorage.instance_variable_set(:@data, {user: {7 => :exit}}) }
      it do
        expect(subject).to eql({})
        adata = DataGenerator::DataStorage.instance_variable_get(:@data)
        expect(adata[:user]).to eql({})
      end

    end
  end
end