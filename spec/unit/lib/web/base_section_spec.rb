require 'spec_helper'
require 'howitzer/web/section_dsl'
require 'howitzer/web/base_section'

RSpec.describe Howitzer::Web::BaseSection do
  describe 'element dsl methods' do
    let(:parent) { double }
    let(:capybara_context) { double }

    let(:klass) { Class.new(described_class) }
    let(:klass_object) { klass.new(parent, capybara_context) }
    before { allow(klass_object).to receive(:capybara_context) { kontext } }

    include_examples :element_dsl
  end
  describe 'DSL' do
    describe '.me' do
      it { expect { described_class.send(:me, '.foo') }.to raise_error(NoMethodError) }
    end
  end

  describe '.default_finder_args' do
    subject { described_class.default_finder_args }
    it { is_expected.to be_nil }
  end

  describe '#parent' do
    subject { described_class.new(:test, 1).parent }
    it { is_expected.to eq(:test) }
  end

  describe '#capybara_context' do
    subject { described_class.new(1, :test).capybara_context }
    it { is_expected.to eq(:test) }
  end

  describe 'includes proxied capybara methods' do
    let(:reciever) { Class.new(described_class).new(:test, 1) }
    include_examples :capybara_methods_proxy
  end
end
