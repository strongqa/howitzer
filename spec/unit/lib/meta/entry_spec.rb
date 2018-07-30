require 'spec_helper'
require 'howitzer/meta/entry'

RSpec.describe Howitzer::Meta::Entry do
  let(:klass) do
    Class.new do
      include Howitzer::Web::ElementDsl
      def capybara_scopes
        @capybara_scopes ||= [Capybara.current_session]
      end

      def foo_section; end

      def bar_section; end

      def foo_sections; end

      def bar_sections; end

      def foo_iframe; end

      def bar_iframe; end

      def has_foo_iframe?; end

      def has_bar_iframe?; end
    end
  end
  let(:klass_object) { klass.new }

  before do
    klass.class_eval do
      element :foo, :xpath, '//a'
      element :bar, '#bar'
    end
  end

  describe '.new' do
    let(:context) { klass.new }
    subject { described_class.new(context) }
    it { expect(subject.context).to eq(context) }
  end

  describe '#elements' do
    subject { described_class.new(klass.new).elements }
    it { expect(subject.map(&:name)).to contain_exactly('foo', 'bar') }
    it { expect(subject.count).to eq(2) }
  end

  describe '#element' do
    subject { described_class.new(klass.new).element('foo') }
    it { expect(subject.name).to eq('foo') }
  end

  describe '#sections' do
    subject { described_class.new(klass.new).sections }
    it { expect(subject.map(&:name)).to contain_exactly('foo', 'bar') }
    it { expect(subject.count).to eq(2) }
  end

  describe '#section' do
    subject { described_class.new(klass.new).section('foo') }
    it { expect(subject.name).to eq('foo') }
  end

  describe '#iframes' do
    subject { described_class.new(klass.new).iframes }
    it { expect(subject.map(&:name)).to eq(%w[foo bar]) }
  end

  describe '#iframe' do
    subject { described_class.new(klass.new).iframe('foo') }
    it { expect(subject.name).to eq('foo') }
  end
end
