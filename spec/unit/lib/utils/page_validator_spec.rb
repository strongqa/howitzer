require 'spec_helper'
require "#{lib_path}/howitzer/utils/page_validator"

describe Howitzer::Utils::PageValidator do
  describe ".validations" do
    it { expect(subject.validations).to eql({}) }
  end
end

describe "PageValidator" do
  let(:web_page) { Class.new { include Howitzer::Utils::PageValidator }.new }
  describe "#check_correct_page_loaded" do
    subject { web_page.check_correct_page_loaded }
    context "when no validation specified" do
      it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::NoValidationError, "No any page validation was found") }
    end
    context "when all validation are specified" do
      before do
        web_page.class.validates :title, pattern: /Foo/
        web_page.class.validates :url, pattern: /Foo/
        web_page.class.validates :element_presence, locator: :test_locator
      end
      it do
        expect(web_page).to receive(:wait_for_url).with(/Foo/).once
        expect(web_page).to receive(:wait_for_title).with(/Foo/).once
        expect(web_page).to receive(:find_element).with(:test_locator)
        subject
      end
    end
  end

  describe ".validates" do
    subject { web_page.class.validates(name, options)}
    context "when name = :url" do
      context "as string" do
        let(:name) { "url" }
        context "when options is correct" do
          context "(as string)" do
            let(:options) { {"pattern" => /foo/} }
            it do
              expect(subject).to be_a(Proc)
              expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:url]).to eql(subject)
            end
          end
          context "(as symbol)" do
            let(:options) { {pattern: /foo/} }
            it do
              expect(subject).to be_a(Proc)
              expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:url]).to eql(subject)
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
          expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:url]).to eql(subject)
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
            expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:title]).to eql(subject)
          end
        end
        context "(as symbol)" do
          let(:options) { {pattern: /foo/} }
          it do
            expect(subject).to be_a(Proc)
            expect(Howitzer::Utils::PageValidator.validations[web_page.class.name][:title]).to eql(subject)
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
