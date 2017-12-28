require 'spec_helper'
require 'howitzer/meta/section'

RSpec.describe Howitzer::Meta::Section do
  let(:context) { double }
  let(:name) { 'foo' }
  let(:section) { described_class.new(name, context) }

  describe '.new' do
    it { expect(section.context).to eq(context) }
    it { expect(section.name).to eq('foo') }
  end

  describe '#capybara_elements' do
    subject { section.capybara_elements }
    let(:capybara_element) { double }
    it do
      expect(context).to receive(:send).with("#{name}_sections") { [capybara_element] }
      expect(capybara_element).to receive(:capybara_context)
      subject
    end
  end

  describe '#capybara_element' do
    let(:capybara_element) { double }
    subject { section.capybara_element }
    context 'when element is present' do
      it do
        expect(context).to receive(:send).with("#{name}_sections") { [capybara_element] }
        expect(capybara_element).to receive(:capybara_context)
        subject
      end
    end
    context 'when element is not found' do
      it do
        expect(context).to receive(:send).with("#{name}_sections") { [] }
        is_expected.to be_nil
      end
    end
  end

  include_examples :meta_highlight_xpath
end
