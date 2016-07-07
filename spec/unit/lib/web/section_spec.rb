require 'spec_helper'
require 'howitzer/web/section'
require 'howitzer/web/element_dsl'
RSpec.describe Howitzer::Web::Section do
  describe 'element dsl methods' do
    let(:parent) { double }
    let(:capybara_context) { double }

    let(:klass) { Class.new(Howitzer::Web::Section) }
    let(:klass_object) { klass.new(parent, capybara_context) }
    before { allow(klass_object).to receive(:context) { kontext } }

    include_examples :element_dsl
  end

  describe 'DSL' do
    describe '.me' do
      let(:section_class) { Class.new(described_class) }
      context 'when args missing' do
        it { expect { section_class.send(:me) }.to raise_error(ArgumentError, 'Finder arguments are missing') }
      end

      context 'when args present' do
        subject { section_class.send(:me, '.foo') }
        it { is_expected.to eq(['.foo']) }
      end

      it 'should be private' do
        expect { section_class.me('.foo') }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.default_finder_args' do
    context 'by default' do
      subject { described_class.default_finder_args }
      it { is_expected.to be_nil }
    end

    context 'when defined via dsl' do
      let(:section_class) do
        Class.new(described_class) do
          me :xpath, './/div'
        end
      end
      subject { section_class.default_finder_args }
      it { is_expected.to eq([:xpath, './/div']) }
    end
  end

  describe '#parent' do
    subject { described_class.new(:test, 1).parent }
    it { is_expected.to eq(:test) }
  end

  describe '#context' do
    subject { described_class.new(1, :test).context }
    it { is_expected.to eq(:test) }
  end
end
