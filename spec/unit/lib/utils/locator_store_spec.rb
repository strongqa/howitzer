require 'spec_helper'
require "#{lib_path}/howitzer/utils/locator_store"

describe "Locator store" do
  before do
    class Foo
      include LocatorStore
    end
  end
  let(:bad_name) { 'name' }
  let(:error) { LocatorStore::ClassMethods::LocatorNotSpecifiedError }
  # Class methods
  describe "when bad locator given" do
    context "#locator" do
      subject { Foo.locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "#link_locator" do
      subject { Foo.link_locator(bad_name) }
      it { expect {subject}. to raise_error(error) }
    end
    context "#field_locator" do
      subject { Foo.field_locator(bad_name) }
      it { expect {subject}. to raise_error(error) }
    end
    context "#button_locator" do
      subject { Foo.button_locator(bad_name) }
      it { expect {subject}. to raise_error(error) }
    end
  end
  describe "when correct locator given" do
    context "#locator" do
      before { Foo.add_locator :base_locator, 'base_locator' }
      subject { Foo.locator(:base_locator) }
      it { expect(subject).to eq('base_locator') }
    end
    context "#link_locator" do
      before { Foo.add_link_locator :link_locator, 'link_locator' }
      subject { Foo.link_locator(:link_locator) }
      it { expect(subject).to eq('link_locator') }
    end
    context "#field_locator" do
      before { Foo.add_field_locator :field_locator, 'field_locator' }
      subject { Foo.field_locator(:field_locator) }
      it { expect(subject).to eq('field_locator') }
    end
    context "#button_locator" do
      before { Foo.add_button_locator :button_locator, 'button_locator' }
      subject { Foo.button_locator(:button_locator) }
      it { expect(subject).to eq('button_locator') }
    end
  end
  #Instance methods
  describe "when bad locator given" do
    context "#locator" do
      subject { Foo.new.locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "#link_locator" do
      subject { Foo.new.link_locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "#field_locator" do
      subject { Foo.new.field_locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
    context "#button_locator" do
      subject { Foo.new.button_locator(bad_name) }
      it { expect {subject}.to raise_error(error) }
    end
  end
  describe "when correct locator given" do
    context "#locator" do
      before { Foo.add_locator :base_locator, 'base_locator' }
      subject { Foo.new.locator(:base_locator) }
      it { expect(subject).to eq('base_locator') }
    end
    context "#link_locator" do
      before { Foo.add_link_locator :link_locator, 'link_locator' }
      subject { Foo.new.link_locator(:link_locator) }
      it { expect(subject).to eq('link_locator') }
    end
    context "#field_locator" do
      before { Foo.add_field_locator :field_locator, 'field_locator' }
      subject { Foo.new.field_locator(:field_locator) }
      it { expect(subject).to eq('field_locator') }
    end
    context "#button_locator" do
      before { Foo.add_button_locator :button_locator, 'button_locator' }
      subject { Foo.new.button_locator(:button_locator) }
      it { expect(subject).to eq('button_locator') }
    end
  end
end