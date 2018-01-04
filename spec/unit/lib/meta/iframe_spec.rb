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
      expect(iframe).to receive(:site_value)
      expect(context).to receive_message_chain(:capybara_context, :all)
      subject
    end
  end

  describe '#capybara_element' do
    subject { iframe.capybara_element }
    context 'when element is present' do
      context 'with default arguments' do
        it do
          expect(iframe).to receive(:site_value)
          expect(context).to receive_message_chain(:capybara_context, :find)
          subject
        end
      end
      context 'with custom arguments' do
        subject { iframe.capybara_element(wait: 5) }
        it do
          expect(iframe).to receive(:site_value)
          expect(context).to receive_message_chain(:capybara_context, :find)
          subject
        end
      end
    end
    context 'when element is not found' do
      before do
        allow(iframe).to receive(:site_value)
        allow(context).to receive_message_chain(:capybara_context, :find) { raise Capybara::ElementNotFound }
      end
      it { is_expected.to be_nil }
    end
  end

  describe '#site_value' do
    subject { iframe.site_value }
    context 'when site value is present' do
      before { iframe.instance_variable_set(:@site_value, 'test') }
      it { is_expected.to eq('test') }
    end
    context 'when site value is blank' do
      it do
        expect(context).to receive(:send).with("#{name}_iframe")
        subject
      end
    end
  end

  include_examples :meta_highlight_xpath
end
