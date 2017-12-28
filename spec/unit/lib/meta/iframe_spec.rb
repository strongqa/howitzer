require 'spec_helper'
require 'howitzer/meta/iframe'

RSpec.describe Howitzer::Meta::Iframe do
  let(:context) { double }
  let(:name) { 'foo' }
  let(:iframe) { described_class.new(name, context) }

  describe '.new' do
    it { expect(iframe.context).to eq(context) }
    it { expect(iframe.name).to eq('foo') }
  end

  describe '#capybara_elements' do
    subject { iframe.capybara_elements }
    it do
      expect(context).to receive(:send).with("#{name}_iframe")
      expect(context).to receive_message_chain(:capybara_context, :all)
      subject
    end
  end

  describe '#capybara_element' do
    subject { iframe.capybara_element }
    context 'when element is present' do
      context 'with default arguments' do
        it do
          expect(context).to receive(:send).with("#{name}_iframe")
          expect(context).to receive_message_chain(:capybara_context, :find)
          subject
        end
      end
      context 'with custom arguments' do
        subject { iframe.capybara_element(wait: 5) }
        it do
          expect(context).to receive(:send).with("#{name}_iframe")
          expect(context).to receive_message_chain(:capybara_context, :find)
          subject
        end
      end
    end
    context 'when element is not found' do
      before do
        allow(context).to receive(:send).with("#{name}_iframe")
        allow(context).to receive_message_chain(:capybara_context, :find) { raise Capybara::ElementNotFound }
      end
      it { is_expected.to be_nil }
    end
  end

  include_examples :meta_highlight_xpath
end
