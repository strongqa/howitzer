require 'spec_helper'
require 'howitzer/utils/locator_store'

describe "Locator store" do
  let(:bad_name) { 'name' }
  let(:error) { Howitzer::LocatorNotDefinedError }

  shared_examples "locator methods" do |prefix, web_page|
    describe "#{prefix}locator" do
      context "when bad locator given" do
        subject { web_page.locator(bad_name) }
        it do
          expect(log).to receive(:error).with(error, bad_name).once.and_call_original
          expect { subject }.to raise_error(error)
        end
      end
      context "when CSS locator given" do
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

    describe "#{prefix}link_locator" do
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

    describe "#{prefix}field_locator" do
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

    describe "#{prefix}button_locator" do
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

    describe "#{prefix}find_element" do
      context "when existing locator name given" do
        context "of base type" do
          before { web_page.add_locator :test_locator, '.foo' }
          subject { web_page.find_element(name) }
          context "as string" do
            let(:name) { "test_locator" }
            it do
              expect(web_page.is_a?(Class) ? web_page : web_page.class).to receive(:find).with('.foo')
              subject
            end
          end
          context "as symbol" do
            let(:name) { :test_locator }
            it do
              expect(web_page.is_a?(Class) ? web_page : web_page.class).to receive(:find).with('.foo')
              subject
            end
          end
        end
        context "when link locator or other" do
          before { web_page.add_link_locator :test_link_locator, 'foo' }
          subject { web_page.find_element(:test_link_locator) }
          it do
            expect(web_page.is_a?(Class) ? web_page : web_page.class).to receive(:find_link).with('foo')
            subject
          end
        end
      end
      context "when not existing locator name" do
        subject { web_page.find_element(:unknown_locator) }
        it { expect{ subject }.to raise_error(Howitzer::LocatorNotDefinedError, "unknown_locator") }
      end
    end
    describe "#{prefix}first_element" do
      context "when existing locator name given" do
        context "of base type" do
          before { web_page.add_locator :test_locator, '.foo' }
          subject { web_page.first_element(name) }
          context "as string" do
            let(:name) { "test_locator" }
            it do
              expect(web_page.is_a?(Class) ? web_page : web_page.class).to receive(:first).with('.foo')
              subject
            end
          end
          context "as symbol" do
            let(:name) { :test_locator }
            it do
              expect(web_page.is_a?(Class) ? web_page : web_page.class).to receive(:first).with('.foo')
              subject
            end
          end
        end
        context "when link locator or other" do
          before { web_page.add_link_locator :test_link_locator, 'foo' }
          subject { web_page.first_element(:test_link_locator) }
          it do
            expect(web_page.is_a?(Class) ? web_page : web_page.class).to receive(:first).with(:link, 'foo')
            subject
          end
        end
      end
      context "when not existing locator name" do
        subject { web_page.first_element(:unknown_locator) }
        it { expect{ subject }.to raise_error(Howitzer::LocatorNotDefinedError, "unknown_locator") }
      end
    end
    describe "#{prefix}apply" do
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
  end

  context "Class methods" do
    it_behaves_like "locator methods", '.', Class.new{ include LocatorStore }
  end

  context "Instance methods" do
    it_behaves_like "locator methods", '#', Class.new{ include LocatorStore }.new
  end

end