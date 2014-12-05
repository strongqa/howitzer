require 'spec_helper'
require 'howitzer/utils/data_generator/data_storage'

RSpec.describe 'DataGenerator' do
  describe 'DataStorage' do
    before { DataGenerator::DataStorage.data.clear }
    describe '.store' do
      subject { DataGenerator::DataStorage.store(ns, 7, :halt) }
      context 'when namespace specified' do
        let(:ns) { :user }
        it 'should return value' do
          is_expected.to eql(:halt)
        end
        it 'should store namespace value' do
          subject
          expect(DataGenerator::DataStorage.data[:user]).to eql({7 => :halt})
        end
      end
      context 'when namespace empty' do
        let(:ns) { nil }
        it { expect {subject}.to raise_error(RuntimeError, 'Data storage namespace can not be empty') }
      end
    end
    describe '.extract' do
      subject { DataGenerator::DataStorage.extract(ns, key) }
      before { DataGenerator::DataStorage.data[:user] = {7 => :exit} }
      describe 'when namespace specified' do
        let(:ns) { :user }
        context 'and namespace key found' do
          let(:key) { 7 }
          it { is_expected.to eql(:exit) }
        end
        context 'and namespace key not found' do
          let(:key) { 5 }
          it { is_expected.to be_nil }
        end
        context 'but namespace key not specified' do
          let(:key) { nil }
          it { is_expected.to eql({ 7 => :exit }) }
        end
      end
      context 'when namespace not found' do
        let(:ns) { :guest }
        let(:key) { 11 }
        it { is_expected.to be_nil }
      end
      context 'when namespace not specified' do
        let(:ns) { nil }
        let(:key) { nil }
        it { expect {subject}.to raise_error(RuntimeError, 'Data storage namespace can not be empty') }
      end
    end
    describe '.clear_ns' do
      subject { DataGenerator::DataStorage.clear_ns(:user) }
      before { DataGenerator::DataStorage.data[:user]= {7 => :exit}}
      it 'should return empty hash' do
        subject
        adata = DataGenerator::DataStorage.instance_variable_get(:@data)
        expect(adata[:user]).to eql({})
      end
    end
    describe '.clear_all_ns' do
      before do
        DataGenerator::DataStorage.store('sauce', :status, false)
        DataGenerator::DataStorage.store(:foo, 'foo', 'some value1')
        DataGenerator::DataStorage.store(:bar, 'bar', 'some value2')
        DataGenerator::DataStorage.store(:baz, 'baz', 'some value3')
      end
      context 'when default argument' do
        before { DataGenerator::DataStorage.clear_all_ns }
        it { expect(DataGenerator::DataStorage.data).to eq({'sauce' =>{:status=>false}, :foo=>{}, :bar=>{}, :baz=>{}}) }
      end
      context 'when custom argument' do
        let(:exception_list) { [:foo, :bar] }
        before { DataGenerator::DataStorage.clear_all_ns(exception_list) }
        it { expect(DataGenerator::DataStorage.data).to eq({'sauce' =>{}, :foo=>{'foo' => 'some value1'}, :bar=>{'bar' => 'some value2'}, :baz=>{}}) }
      end
    end
  end
end