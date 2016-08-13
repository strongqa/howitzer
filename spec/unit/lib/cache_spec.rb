require 'spec_helper'
require 'howitzer/cache'

RSpec.describe Howitzer::Cache do
  before { described_class.data.clear }
  describe '.store' do
    subject { described_class.store(ns, 7, :halt) }
    context 'when namespace specified' do
      let(:ns) { :user }
      it 'should return value' do
        is_expected.to eql(:halt)
      end
      it 'should store namespace value' do
        subject
        expect(described_class.data[:user]).to eql(7 => :halt)
      end
    end
    context 'when namespace empty' do
      let(:ns) { nil }
      it { expect { subject }.to raise_error(RuntimeError, 'Data storage namespace can not be empty') }
    end
  end
  describe '.extract' do
    subject { described_class.extract(ns, key) }
    before { described_class.data[:user] = { 7 => :exit } }
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
        it { is_expected.to eql(7 => :exit) }
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
      it { expect { subject }.to raise_error(RuntimeError, 'Data storage namespace can not be empty') }
    end
  end
  describe '.clear_ns' do
    subject { described_class.clear_ns(:user) }
    before { described_class.data[:user] = { 7 => :exit } }
    it 'should return empty hash' do
      subject
      data = described_class.instance_variable_get(:@data)
      expect(data[:user]).to eql({})
    end
  end
  describe '.clear_all_ns' do
    before do
      described_class.store(:cloud, :status, false)
      described_class.store(:foo, 'foo', 'some value1')
      described_class.store(:bar, 'bar', 'some value2')
      described_class.store(:baz, 'baz', 'some value3')
    end
    context 'when default argument' do
      before { described_class.clear_all_ns }
      it { expect(described_class.data).to eq(cloud: { status: false }, foo: {}, bar: {}, baz: {}) }
    end
    context 'when custom argument' do
      let(:exception_list) { [:foo, :bar] }
      before { described_class.clear_all_ns(exception_list) }
      it do
        expect(described_class.data).to eq(
          cloud: {},
          foo: { 'foo' => 'some value1' },
          bar: { 'bar' => 'some value2' },
          baz: {}
        )
      end
    end
  end
end
