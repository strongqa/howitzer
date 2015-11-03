require 'spec_helper'
require 'howitzer/capybara/dsl_ex'

RSpec.describe Howitzer::Capybara::DslEx do
  let(:test_page_klass) do
    klass = described_class
    Class.new do
      include klass
      extend klass
    end
  end
  let(:test_page) { test_page_klass.new }

  describe '#find' do
    context 'when string argument with block' do
      subject { test_page.find('foo') { 'bar' } }
      it do
        expect(test_page.page).to receive(:find).with('foo').and_yield.once
        subject
      end
    end
    context 'when first hash argument and second hash' do
      subject { test_page.find({ xpath: '//bar' }, with: 'foo') }
      it do
        expect(test_page.page).to receive(:find).with(:xpath, '//bar', with: 'foo').once
        subject
      end
    end
    context 'when array argument' do
      subject { test_page.find([:xpath, '//bar']) }
      it do
        expect(test_page.page).to receive(:find).with(:xpath, '//bar').once
        subject
      end
    end
  end

  describe '.find' do
    context 'when string argument with block' do
      subject { test_page_klass.find('foo') { 'bar' } }
      it do
        expect(test_page.page).to receive(:find).with('foo').and_yield.once
        subject
      end
    end
    context 'when first hash argument and second hash' do
      subject { test_page_klass.find({ xpath: '//bar' }, with: 'foo') }
      it do
        expect(test_page.page).to receive(:find).with(:xpath, '//bar', with: 'foo').once
        subject
      end
    end
    context 'when array argument' do
      subject { test_page_klass.find([:xpath, '//bar']) }
      it do
        expect(test_page.page).to receive(:find).with(:xpath, '//bar').once
        subject
      end
    end
  end
end
