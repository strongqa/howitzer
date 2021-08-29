require 'spec_helper'
require 'howitzer/web/page_validator'
require 'howitzer/web/element_dsl'

RSpec.describe Howitzer::Web::PageValidator do
  describe '.validations' do
    it { expect(subject.validations).to be_a(Hash) }
  end

  let(:web_page_class) do
    Class.new do
      include Howitzer::Web::ElementDsl
      include Howitzer::Web::PageValidator
      element :foo, 'a'
      element :bar, :xpath, ->(a, b, c:, d:) {}
      def self.name
        'TestWebPageClass'
      end
    end
  end
  let(:web_page) { web_page_class.new }
  describe '#check_validations_are_defined!' do
    subject { web_page.check_validations_are_defined! }
    context 'when no validation specified' do
      it do
        expect { subject }.to raise_error(
          Howitzer::NoValidationError,
          "No any page validation was found for 'TestWebPageClass' page"
        )
      end
    end
    context 'when at least 1 validation is specified' do
      before do
        web_page_class.validations[web_page_class] = { url: -> {} }
      end
      it { expect { subject }.to_not raise_error }
    end
  end

  describe '.validate' do
    before do
      described_class.validations[web_page_class] = nil
    end
    let(:args) { [] }
    let(:options) { {} }
    subject { web_page_class.validate(type, pattern, *args, **options) }
    context 'when type is url' do
      context 'as string' do
        let(:type) { 'url' }
        context 'with string pattern' do
          let(:pattern) { 'foo' }
          it do
            is_expected.to be_a(Proc)
            expect(described_class.validations[web_page_class][:url]).to eql(subject)
          end
        end
        context 'with regexp pattern' do
          let(:pattern) { /foo/ }
          it do
            is_expected.to be_a(Proc)
            expect(described_class.validations[web_page_class][:url]).to eql(subject)
          end
        end
        context 'with incorrect arguments' do
          let(:pattern) { 'foo' }
          context 'when extra arguments' do
            let(:args) { ['extra'] }
            it do
              expect { subject }.to raise_error(
                ArgumentError, "Additional arguments and options are not supported by 'url' the validator"
              )
            end
          end
          context 'when options specified' do
            let(:options) { { extra: :options } }
            it do
              expect { subject }.to raise_error(
                ArgumentError, "Additional arguments and options are not supported by 'url' the validator"
              )
            end
          end
        end
      end
      context 'as symbol' do
        let(:type) { :url }
        let(:pattern) { /foo/ }
        it do
          is_expected.to be_a(Proc)
          expect(described_class.validations[web_page_class][:url]).to eql(subject)
        end
      end
    end
    context 'when type is element_presence' do
      let(:type) { :element_presence }
      let(:args) { %w[a b] }
      let(:options) { { c: 'c', d: 'd' } }
      context 'with string element name' do
        let(:pattern) { 'bar' }
        it do
          is_expected.to be_a(Proc)
          expect(described_class.validations[web_page_class][:element_presence]).to eql(subject)
        end
      end
      context 'with symbol element name' do
        let(:pattern) { :foo }
        it do
          is_expected.to be_a(Proc)
          expect(described_class.validations[web_page_class][:element_presence]).to eql(subject)
        end
      end
      context 'when refers to unknown element' do
        let(:pattern) { :unknown }
        it do
          subject
          expect do
            described_class.validations[web_page_class][:element_presence].call(web_page, false)
          end.to raise_error(
            Howitzer::UndefinedElementError,
            ":element_presence validation refers to undefined 'unknown' element on 'TestWebPageClass' page."
          )
        end
      end
    end
    context 'when type is title' do
      let(:type) { :title }
      context 'with string pattern' do
        let(:pattern) { 'foo' }
        it do
          is_expected.to be_a(Proc)
          expect(described_class.validations[web_page_class][:title]).to eql(subject)
        end
      end
      context 'with regexp pattern' do
        let(:pattern) { /foo/ }
        it do
          is_expected.to be_a(Proc)
          expect(described_class.validations[web_page_class][:title]).to eql(subject)
        end
      end
      context 'with incorrect arguments' do
        let(:pattern) { 'foo' }
        context 'when extra arguments' do
          let(:args) { ['extra'] }
          it do
            expect { subject }.to raise_error(
              ArgumentError, "Additional arguments and options are not supported by 'title' the validator"
            )
          end
        end
        context 'when options specified' do
          let(:options) { { extra: :options } }
          it do
            expect { subject }.to raise_error(
              ArgumentError, "Additional arguments and options are not supported by 'title' the validator"
            )
          end
        end
      end
    end
    context 'when unknown type' do
      let(:type) { :unknown }
      let(:pattern) { '' }
      it do
        expect { subject }.to raise_error(Howitzer::UnknownValidationError, "unknown 'unknown' validation type")
      end
    end
  end

  describe '.opened?' do
    context 'when no one validation is defined' do
      subject { web_page_class.opened? }
      it do
        expect { subject }.to raise_error(
          Howitzer::NoValidationError,
          "No any page validation was found for 'TestWebPageClass' page"
        )
      end
    end
    context 'when all validations are defined' do
      context 'when sync is default' do
        subject { web_page_class.opened? }
        before do
          web_page_class.class_eval do
            include Singleton
            element :login, :xpath, ->(a, b, c:, d:) { ".//#{a}/#{b}[c='#{c}'][d='#{d}']" }
            validate :url, /foo/
            validate :title, /Foo page/
            validate :element_presence, :login, lambda_args('a', 'b', c: 'c', d: 'd'), wait: 10
          end
        end
        context 'when all matches' do
          before do
            allow(web_page_class.instance).to receive(:current_url).and_return('http://test.com/foo')
            allow(web_page_class.instance).to receive(:has_title?).and_return('Foo page')
            allow(web_page_class.instance).to receive(:has_login_element?)
              .with(web_page_class.send(:lambda_args, 'a', 'b', c: 'c', d: 'd'), wait: 10).and_return(true)
          end
          it { is_expected.to be_truthy }
        end
        context 'when first validation fails' do
          before do
            expect(web_page_class.instance).to receive(:current_url).once.and_return('http://test.com/bar')
            expect(web_page_class.instance).to receive(:has_title?).never
            allow(web_page_class).to receive(:has_login_element?).never
          end
          it { is_expected.to be_falsey }
        end
      end

      context 'when sync is true' do
        subject { web_page_class.opened?(sync: true) }
        before do
          web_page_class.class_eval do
            include Singleton
            element :login, :xpath, ->(a, b, c:, d:) { ".//#{a}/#{b}[c='#{c}'][d='#{d}']" }
            validate :url, /foo/
            validate :title, /Foo page/
            validate :element_presence, :login, lambda_args('a', 'b', c: 'c', d: 'd'), wait: 10
          end
        end
        context 'when all matches' do
          before do
            allow(web_page_class.instance).to receive(:current_url).and_return('http://test.com/foo')
            allow(web_page_class.instance).to receive(:has_title?).and_return('Foo page')
            allow(web_page_class.instance).to receive(:has_login_element?)
              .with(web_page_class.send(:lambda_args, 'a', 'b', c: 'c', d: 'd'), wait: 10).and_return(true)
          end
          it { is_expected.to be_truthy }
        end
        context 'when first validation fails' do
          before do
            expect(web_page_class.instance).to receive(:current_url).once.and_return('http://test.com/bar')
            expect(web_page_class.instance).to receive(:has_title?).never
            allow(web_page_class).to receive(:has_login_element?).never
          end
          it { is_expected.to be_falsey }
        end
      end

      context 'when sync is false' do
        subject { web_page_class.opened?(sync: false) }
        before do
          web_page_class.class_eval do
            include Singleton
            element :login, :xpath, ->(a, b, c:, d:) { ".//#{a}/#{b}[c='#{c}'][d='#{d}']" }
            validate :url, /foo/
            validate :title, /Foo page/
            validate :element_presence, :login, lambda_args('a', 'b', c: 'c', d: 'd'), wait: 10
          end
        end
        context 'when all matches' do
          before do
            allow(web_page_class.instance).to receive(:current_url).and_return('http://test.com/foo')
            allow(web_page_class.instance).to receive(:title).and_return('Foo page')
            allow(web_page_class.instance).to receive(:has_no_login_element?)
              .with(web_page_class.send(:lambda_args, 'a', 'b', c: 'c', d: 'd'), wait: 10).and_return(false)
          end
          it { is_expected.to be_truthy }
        end
        context 'when first validation fails' do
          before do
            expect(web_page_class.instance).to receive(:current_url).once.and_return('http://test.com/bar')
            expect(web_page_class.instance).to receive(:title).never
            allow(web_page_class).to receive(:has_no_login_element?).never
          end
          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe 'web_page.validations' do
    it { expect(web_page_class.validations).to be_a(Hash) }
  end

  describe '#matched_pages' do
    let!(:web_page1_class) do
      Class.new do
        include Howitzer::Web::PageValidator
      end
    end
    let!(:web_page2_class) do
      Class.new do
        include Howitzer::Web::PageValidator
      end
    end
    subject { web_page2_class.matched_pages }
    before do
      allow(Howitzer::Web::PageValidator).to receive(:validations).with(no_args) do
        { web_page1_class => 1, web_page2_class => 2 }
      end
      expect(web_page1_class).to receive(:opened?).with(sync: false).and_return(true)
      expect(web_page2_class).to receive(:opened?).with(sync: false).and_return(false)
    end
    it { is_expected.to eq([web_page1_class]) }
  end
end
