require 'spec_helper'
require 'howitzer/web_page_validator'
require 'howitzer/web_page_element'

RSpec.describe Howitzer::WebPageValidator do
  describe '.validations' do
    it { expect(subject.validations).to eql({}) }
  end
end

RSpec.describe 'WebPageValidator' do
  let(:web_page_class) do
    Class.new do
      include Howitzer::WebPageElement
      include Howitzer::WebPageValidator
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
        expect(log).to receive(:error).with(
          Howitzer::NoValidationError,
          "No any page validation was found for 'TestWebPageClass' page"
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::NoValidationError)
      end
    end
    context 'when title validation is specified' do
      before do
        web_page.class.validate :title, pattern: /Foo/
      end
      it { expect { subject }.to_not raise_error }
    end
    context 'when url validation is specified' do
      before do
        web_page.class.validate :url, pattern: /Foo/
      end
      it { expect { subject }.to_not raise_error }
    end
    context 'when element_presence validation is specified' do
      before do
        web_page.class.validate :element_presence, name: :test_locator
      end
      it { expect { subject }.to_not raise_error }
    end
  end

  describe '.validate' do
    before do
      Howitzer::WebPageValidator.validations[web_page.class.name] = nil
    end
    subject { web_page.class.validate(name, options) }
    context 'when name = :url' do
      context 'as string' do
        let(:name) { 'url' }
        context 'when options is correct' do
          context '(as string)' do
            let(:options) { { 'pattern' => /foo/ } }
            it do
              is_expected.to be_a(Proc)
              expect(Howitzer::WebPageValidator.validations[web_page.class.name][:url]).to be_a Proc
            end
          end
          context '(as symbol)' do
            let(:options) { { pattern: /foo/ } }
            it do
              is_expected.to be_a(Proc)
              expect(Howitzer::WebPageValidator.validations[web_page.class.name][:url]).to be_a Proc
            end
          end
        end
        context 'when options is incorrect' do
          context '(missing pattern)' do
            let(:options) { {} }
            it do
              expect(log).to receive(:error).with(
                Howitzer::WrongOptionError,
                "Please specify ':pattern' option as Regexp object"
              ).once.and_call_original
              expect { subject }.to raise_error(Howitzer::WrongOptionError)
            end
          end
          context '(string pattern)' do
            let(:options) { { pattern: 'foo' } }
            it do
              expect(log).to receive(:error).with(
                Howitzer::WrongOptionError,
                "Please specify ':pattern' option as Regexp object"
              ).once.and_call_original
              expect { subject }.to raise_error(Howitzer::WrongOptionError)
            end
          end
          context '(not hash)' do
            let(:options) { 'foo' }
            it { expect { subject }.to raise_error(TypeError, "Expected options to be Hash, actual is 'String'") }
          end
        end
      end
      context 'as symbol' do
        let(:name) { :url }
        let(:options) { { pattern: /foo/ } }
        it do
          is_expected.to be_a(Proc)
          expect(Howitzer::WebPageValidator.validations[web_page.class.name][:url]).to be_a Proc
        end
      end
    end
    context 'when name = :element_presence' do
      let(:name) { :element_presence }
      context 'when options is correct' do
        context '(as string)' do
          let(:options) { { 'name' => 'test_locator' } }
          it do
            is_expected.to be_a(Proc)
            expect(Howitzer::WebPageValidator.validations[web_page.class.name][:element_presence]).to eql(subject)
          end
        end
        context '(as symbol)' do
          let(:options) { { name: :test_locator } }
          it do
            is_expected.to be_a(Proc)
            expect(Howitzer::WebPageValidator.validations[web_page.class.name][:element_presence]).to eql(subject)
          end
        end
      end
      context 'when options is incorrect' do
        context '(missing element name)' do
          let(:options) { {} }
          it do
            expect(log).to receive(:error).with(
              Howitzer::WrongOptionError,
              "Please specify ':name' option as one of page element names"
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::WrongOptionError)
          end
        end
        context '(blank element name)' do
          let(:options) { { element: '' } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::WrongOptionError,
              "Please specify ':name' option as one of page element names"
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::WrongOptionError)
          end
        end
      end
    end
    context 'when name = :title' do
      let(:name) { :title }
      context 'when options is correct' do
        context '(as string)' do
          let(:options) { { 'pattern' => /foo/ } }
          it do
            is_expected.to be_a(Proc)
            expect(Howitzer::WebPageValidator.validations[web_page.class.name][:title]).to be_a Proc
          end
        end
        context '(as symbol)' do
          let(:options) { { pattern: /foo/ } }
          it do
            is_expected.to be_a(Proc)
            expect(Howitzer::WebPageValidator.validations[web_page.class.name][:title]).to be_a Proc
          end
        end
      end
      context 'when options is incorrect' do
        context '(missing pattern)' do
          let(:options) { {} }
          it do
            expect(log).to receive(:error).with(
              Howitzer::WrongOptionError,
              "Please specify ':pattern' option as Regexp object"
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::WrongOptionError)
          end
        end
        context '(string pattern)' do
          let(:options) { { pattern: 'foo' } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::WrongOptionError,
              "Please specify ':pattern' option as Regexp object"
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::WrongOptionError)
          end
        end
      end
    end
    context 'when other name' do
      let(:name) { :unknown }
      let(:options) { {} }
      it do
        expect(log).to receive(:error).with(
          Howitzer::UnknownValidationError,
          "unknown 'unknown' validation type"
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::UnknownValidationError)
      end
    end
  end

  describe '.pages' do
    subject { Howitzer::WebPageValidator.pages }
    it { is_expected.to eq([]) }
    it do
      subject << Class
      is_expected.to eql([Class])
    end
  end

  describe '.opened?' do
    subject { web_page_class.opened? }
    context 'when no one validation is defined' do
      it do
        expect(log).to receive(:error).with(
          Howitzer::NoValidationError,
          "No any page validation was found for 'TestWebPageClass' page"
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::NoValidationError)
      end
    end
    context 'when all validations are defined' do
      before do
        web_page_class.class_eval do
          element :login, '#id'
          validate :url, pattern: /foo/
          validate :title, pattern: /Foo page/
          validate :element_presence, name: :login
        end
      end
      context 'when all matches' do
        before do
          allow(web_page_class).to receive(:current_url) { 'http://test.com/foo' }
          allow(web_page_class).to receive(:title) { 'Foo page' }
          allow(web_page_class).to receive(:has_login_element?).with(no_args) { true }
        end
        it { is_expected.to be_truthy }
      end
      context 'when first validation fails' do
        before do
          expect(web_page_class).to receive(:current_url).once { 'http://test.com/bar' }
          expect(web_page_class).to receive(:title).never
          allow(web_page_class).to receive(:has_login_element?).with(no_args).never
        end
        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#matched_pages' do
    let!(:web_page1_class) do
      Class.new do
        include Howitzer::WebPageValidator
        def self.name
          'TestWebPage1Class'
        end

        def self.opened?
          true
        end
      end
    end

    let!(:web_page2_class) do
      Class.new do
        include Howitzer::WebPageValidator
        def self.name
          'TestWebPage2Class'
        end

        def self.opened?
          false
        end
      end
    end
    subject { web_page2_class.matched_pages }
    before { Howitzer::WebPageValidator.instance_variable_set(:@pages, [web_page1_class, web_page2_class]) }
    it { is_expected.to eq([web_page1_class]) }
  end
end
