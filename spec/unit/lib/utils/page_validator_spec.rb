require 'spec_helper'
require "#{lib_path}/howitzer/utils/page_validator"

describe Howitzer::Utils::PageValidator do
  describe ".validations" do
    it { expect(subject.validations).to eql({}) }
  end
end

describe "PageValidator" do
  let(:web_page_class) do
    Class.new do
      include Howitzer::Utils::PageValidator
      def self.name
        'TestWebPageClass'
      end
    end
  end
  let(:web_page) { web_page_class.new }
  describe "#check_validations_are_defined!" do
    subject { web_page.check_validations_are_defined! }
    context "when no validation specified" do
      it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::NoValidationError, "No any page validation was found for 'TestWebPageClass' page") }
    end
    context "when old validation style is using" do
      before { web_page_class.const_set("URL_PATTERN",/Foo/) }
      after { web_page_class.send :remove_const, "URL_PATTERN"}
      it do
        expect(web_page_class).to receive(:validates).with(:url, pattern: /Foo/).and_return{ Howitzer::Utils::PageValidator.validations['TestWebPageClass'] = {}}
        expect{subject}.to_not raise_error
      end
    end
    context "when title validation is specified" do
      before do
        web_page.class.validates :title, pattern: /Foo/
      end
      it { expect{subject}.to_not raise_error }
    end
    context "when url validation is specified" do
      before do
        web_page.class.validates :url, pattern: /Foo/
      end
      it { expect{subject}.to_not raise_error }
    end
    context "when element_presence validation is specified" do
      before do
        web_page.class.validates :element_presence, locator: :test_locator
      end
      it { expect{subject}.to_not raise_error }
    end
  end

  describe ".validates" do
    before do
      Howitzer::Utils::PageValidator.validations[web_page.class.name] = nil
    end
    subject { web_page.class.validates(name, options) }
    context "when name = :url" do
      context "as string" do
        let(:name) { "url" }
        context "when options is correct" do
          context "(as string)" do
            let(:options) { {"pattern" => /foo/} }
            it do
              expect(subject).to be_a(Proc)
              expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:url]).to be_a Proc
            end
          end
          context "(as symbol)" do
            let(:options) { {pattern: /foo/} }
            it do
              expect(subject).to be_a(Proc)
              expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:url]).to be_a Proc
            end
          end
        end
        context "when options is incorrect" do
          context "(missing pattern)" do
            let(:options) { {} }
            it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::WrongOptionError, "Please specify ':pattern' option as Regexp object") }
          end
          context "(string pattern)" do
            let(:options) { {pattern: "foo"} }
            it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::WrongOptionError, "Please specify ':pattern' option as Regexp object") }
          end
          context "(not hash)" do
            let(:options) { "foo" }
            it { expect{subject}.to raise_error(TypeError, "Expected options to be Hash, actual is 'String'") }
          end
        end
      end
      context "as symbol" do
        let(:name) { :url }
        let(:options) { {pattern: /foo/} }
        it do
          expect(subject).to be_a(Proc)
          expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:url]).to be_a Proc
        end
      end
    end
    context "when name = :element_presence" do
      let(:name) { :element_presence }
      context "when options is correct" do
        context "(as string)" do
          let(:options) { {"locator" => 'test_locator'} }
          it do
            expect(subject).to be_a(Proc)
            expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:element_presence]).to eql(subject)
          end
        end
        context "(as symbol)" do
          let(:options) { {locator: :test_locator} }
          it do
            expect(subject).to be_a(Proc)
            expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:element_presence]).to eql(subject)
          end
        end
      end
      context "when options is incorrect" do
        context "(missing locator)" do
          let(:options) { {} }
          it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::WrongOptionError, "Please specify ':locator' option as one of page locator names") }
        end
        context "(blank locator name)" do
          let(:options) { {locator: ""} }
          it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::WrongOptionError, "Please specify ':locator' option as one of page locator names") }
        end
      end
    end
    context "when name = :title" do
      let(:name) { :title }
      context "when options is correct" do
        context "(as string)" do
          let(:options) { {"pattern" => /foo/} }
          it do
            expect(subject).to be_a(Proc)
            expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:title]).to be_a Proc
          end
        end
        context "(as symbol)" do
          let(:options) { {pattern: /foo/} }
          it do
            expect(subject).to be_a(Proc)
            expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:title]).to be_a Proc
          end
        end
      end
      context "when options is incorrect" do
        context "(missing pattern)" do
          let(:options) { {} }
          it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::WrongOptionError, "Please specify ':pattern' option as Regexp object") }
        end
        context "(string pattern)" do
          let(:options) { {pattern: "foo"} }
          it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::WrongOptionError, "Please specify ':pattern' option as Regexp object") }
        end
      end
    end
    context "when other name" do
      let(:name) { :unknown }
      let(:options) { {} }
      it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::UnknownValidationName, "unknown 'unknown' validation name") }
    end
  end

end
