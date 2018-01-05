require 'spec_helper'
require 'howitzer/web/section_dsl'
require 'howitzer/web/section'
RSpec.describe Howitzer::Web::Section do
  describe 'element dsl methods' do
    let(:parent) { double }
    let(:capybara_context) { double }

    let(:klass) { Class.new(described_class) }
    let(:klass_object) { klass.new(parent, capybara_context) }

    it 'returns correct capybara context' do
      expect(klass_object.capybara_context).to eq(capybara_context)
    end

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

  describe '#capybara_context' do
    subject { described_class.new(1, :test).capybara_context }
    it { is_expected.to eq(:test) }
  end

  describe '#meta' do
    let(:section) { described_class.new(1, :test) }
    it { expect(section.meta).to be_an_instance_of(Howitzer::Meta::Entry) }
    it { expect(section.meta.context).to eq(section) }
    it { expect(section.instance_variable_get(:@meta)).to be_nil }
  end
end
