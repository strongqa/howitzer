require 'spec_helper'
require 'howitzer/meta/element'

RSpec.describe Howitzer::Meta::Element do
  let(:context) { double }
  let(:name) { 'foo' }
  let(:element) { described_class.new(name, context) }

  describe '.new' do
    it { expect(element.context).to eq(context) }
    it { expect(element.name).to eq('foo') }
  end

  describe '#capybara_elements' do
    context 'without arguments' do
      subject { element.capybara_elements }
      it do
        expect(context).to receive(:send).with("#{name}_elements")
        subject
      end
    end
    context 'whith custom arguments' do
      subject { element.capybara_elements('test', text: 'test', wait: 5) }
      it do
        expect(context).to receive(:send).with("#{name}_elements", 'test', text: 'test', wait: 5)
        subject
      end
    end
  end

  describe '#capybara_element' do
    subject { element.capybara_element }
    context 'when element is present' do
      context 'with default arguments' do
        it do
          expect(context).to receive(:send).with("#{name}_element", match: :first, wait: 0)
          subject
        end
      end
      context 'with custom arguments' do
        subject { element.capybara_element('test', { text: 'test' }, wait: 5) }
        it do
          expect(context).to receive(:send).with("#{name}_element", 'test', { text: 'test' }, match: :first, wait: 5)
          subject
        end
      end
    end
    context 'when element is not found' do
      before do
        allow(context).to receive(:send).with("#{name}_element", match: :first, wait: 0) do
          raise Capybara::ElementNotFound
        end
      end
      it { is_expected.to be_nil }
    end
  end

  include_examples :meta_highlight_xpath
end
