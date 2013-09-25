require 'spec_helper'
require "#{lib_path}/howitzer/utils/locator_store"

describe "Locator store" do
  before do
    #class Foo
    #  include LocatorStore
    #end
  end
  let(:bad_name) { 'name' }
  let(:error) { LocatorStore::ClassMethods::LocatorNotSpecifiedError }
  let(:web_page) { Class.new{ include LocatorStore } }

  describe ".locator" do
    context "when bad locator given" do
      subject { web_page.locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_locator :base_locator, 'base_locator' }
      subject { web_page.locator(:base_locator) }
      it { expect(subject).to eq('base_locator') }
    end
    context "when XPATH locator given" do
      before { web_page.add_locator :test_xpath, xpath: "//select[@id='modelOptions']/option[@value='m6']" }
      subject { web_page.locator(:test_xpath) }
      it { expect(subject).to eq([:xpath, "//select[@id='modelOptions']/option[@value='m6']"]) }
    end
  end

  describe ".link_locator" do
    context "when bad locator given" do
      subject { web_page.link_locator(bad_name) }
      it { expect {subject}. to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_link_locator :link_locator, 'link_locator' }
      subject { web_page.link_locator(:link_locator) }
      it { expect(subject).to eq('link_locator') }
    end
  end

  describe ".field_locator" do
    context "when bad locator given" do
      subject { web_page.field_locator(bad_name) }
      it { expect {subject}. to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_field_locator :field_locator, 'field_locator' }
      subject { web_page.field_locator(:field_locator) }
      it { expect(subject).to eq('field_locator') }
    end
  end

  describe ".button_locator" do
    context "when bad locator given" do
      subject { web_page.button_locator(bad_name) }
      it { expect {subject}. to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_button_locator :button_locator, 'button_locator' }
      subject { web_page.button_locator(:button_locator) }
      it { expect(subject).to eq('button_locator') }
    end
  end

  describe "#locator" do
    context "when bad locator given" do
      subject { web_page.new.locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_locator :base_locator, 'base_locator' }
      subject { web_page.new.locator(:base_locator) }
      it { expect(subject).to eq('base_locator') }
    end
    context "when XPATH locator given" do
      before { web_page.add_locator :test_xpath, xpath: "//select[@id='modelOptions']/option[@value='m6']" }
      subject { web_page.new.locator(:test_xpath) }
      it { expect(subject).to eq([:xpath, "//select[@id='modelOptions']/option[@value='m6']"]) }
    end
  end

  describe "#link_locator" do
    context "when bad locator given" do
      subject { web_page.new.link_locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_link_locator :link_locator, 'link_locator' }
      subject { web_page.new.link_locator(:link_locator) }
      it { expect(subject).to eq('link_locator') }
    end
  end

  describe "#field_locator" do
    context "when bad locator given" do
      subject { web_page.new.field_locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_field_locator :field_locator, 'field_locator' }
      subject { web_page.new.field_locator(:field_locator) }
      it { expect(subject).to eq('field_locator') }
    end
  end

  describe "#button_locator" do
    context "when bad locator given" do
      subject { web_page.new.button_locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "when correct locator given" do
      before { web_page.add_button_locator :button_locator, 'button_locator' }
      subject { web_page.new.button_locator(:button_locator) }
      it { expect(subject).to eq('button_locator') }
    end
  end
  describe ".apply" do
    context "when bad locator given" do
      before { web_page.add_locator :test_locator,  lambda{|test| test} }
      let(:locator)  { lambda{|test| test}  }
      subject { web_page.apply(locator, 'test') }
      it { expect {subject}.to raise_error(NoMethodError) }

    end
    context "when correct locator given" do
      before { web_page.add_locator :test_locator,  lambda{|location_name| {xpath: ".//a[contains(.,'#{location_name}')]"}} }
      let(:locator) { lambda{|location_name| {xpath: ".//a[contains(.,'#{location_name}')]"}} }
      subject { web_page.apply(locator, 'Kiev') }
      it { expect(subject).to eq([:xpath, ".//a[contains(.,'Kiev')]"]) }
    end
  end
  describe "#apply" do
    context "when bad locator given" do
      before { web_page.add_locator :test_locator,  lambda{|test| test} }
      let(:locator)  { lambda{|test| test}  }
      subject { web_page.new.apply(locator, 'test') }
      it { expect {subject}.to raise_error(NoMethodError) }

    end
    context "when correct locator given" do
      before { web_page.add_locator :test_locator,  lambda{|location_name| {xpath: ".//a[contains(.,'#{location_name}')]"}} }
      let(:locator) { lambda{|location_name| {xpath: ".//a[contains(.,'#{location_name}')]"}} }
      subject { web_page.new.apply(locator, 'Kiev') }
      it { expect(subject).to eq([:xpath, ".//a[contains(.,'Kiev')]"]) }
    end
  end

end