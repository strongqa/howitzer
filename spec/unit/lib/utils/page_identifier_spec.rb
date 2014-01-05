require 'spec_helper'
require "#{lib_path}/howitzer/utils/page_identifier"

def specify_page_validations(page, validations = {})
  Howitzer::Utils::PageIdentifier.validations.clear
  Howitzer::Utils::PageIdentifier.validations[page] = {}
  if validations.key?(:url)
    url_pattern = validations[:url] ? // : /not_matches/
    Howitzer::Utils::PageIdentifier.validations[page][:url] = lambda { |url| url_pattern === url }
  end

  if validations.key?(:title)
    title_pattern = validations[:title] ? // : /not_matches/
    Howitzer::Utils::PageIdentifier.validations[page][:title] = lambda { |title| title_pattern === title }
  end
end

describe Howitzer::Utils::PageIdentifier do
  describe ".validations" do
    it { expect(subject.validations).to eql({}) }
  end

  describe ".identify_page" do
    subject { Howitzer::Utils::PageIdentifier.identify_page(url, title) }
    let(:test_page) { "TestPage" }
    context "when correct arguments" do
      let(:url) { 'http://test.com' }
      let(:title) { 'Test Title' }
      context "when page has url and title validation" do
        context "when url and title matches once" do
          before { specify_page_validations(test_page, url: true, title: true) }
          it { expect(subject).to eql [test_page] }
        end
        context "when url and title matches twice" do
          before do
            specify_page_validations("TestPage", url: true, title: true)
            v1 = Howitzer::Utils::PageIdentifier.validations["TestPage"]
            specify_page_validations("TestPage1", url: true, title: true)
            Howitzer::Utils::PageIdentifier.validations["TestPage"] = v1
          end
          it { expect(subject).to eql ["TestPage", "TestPage1"] }
        end
        context "when url matches only" do
          before { specify_page_validations(test_page, url: true, title: false) }
          it { expect(subject).to eql [] }
        end
        context "when title matches only" do
          before { specify_page_validations(test_page, url: false, title: true) }
          it { expect(subject).to eql [] }
        end
        context "when url and title does not match" do
          before { specify_page_validations(test_page, url: false, title: false) }
          it { expect(subject).to eql [] }
        end
      end
      context "when page has url validation only" do
        context "when url matches" do
          before { specify_page_validations(test_page, url: true) }
          it { expect(subject).to eql [test_page] }
        end
        context "when url does not match" do
          before { specify_page_validations(test_page, url: false) }
          it { expect(subject).to eql [] }
        end
      end
      context "when page has title validation only" do
        context "when title matches" do
          before { specify_page_validations(test_page, title: true) }
          it { expect(subject).to eql [test_page] }
        end
        context "when title does not match" do
          before { specify_page_validations(test_page, title: false) }
          it { expect(subject).to eql [] }
        end
      end
      context "when page does not have url and title validation" do
        before { specify_page_validations(test_page, {}) }
        it { expect{subject}.to raise_error(Howitzer::Utils::PageValidator::NoValidationError, "No any page validation was found for '#{test_page}' page") }
      end
    end
    context "when url nil" do
      let(:url) { nil }
      let(:title) { 'Test Title' }
      subject { expect { subject }.to raise_error(Howitzer::Utils::PageIdentifier::ArgumentError, "Url and title can not be blank. Actual: url=#{url}, title=#{title}") }
    end
    context "when url blank string" do
      let(:url) { '' }
      let(:title) { 'Test Title' }
      subject { expect { subject }.to raise_error(Howitzer::Utils::PageIdentifier::ArgumentError, "Url and title can not be blank. Actual: url=#{url}, title=#{title}") }
    end
    context "when title nil" do
      let(:url) { 'http://test.com' }
      let(:title) { nil }
      subject { expect { subject }.to raise_error(Howitzer::Utils::PageIdentifier::ArgumentError, "Url and title can not be blank. Actual: url=#{url}, title=#{title}") }
    end
    context "when title blank string" do
      let(:url) { 'http://test.com' }
      let(:title) { '' }
      subject { expect { subject }.to raise_error(Howitzer::Utils::PageIdentifier::ArgumentError, "Url and title can not be blank. Actual: url=#{url}, title=#{title}") }
    end
  end
end
