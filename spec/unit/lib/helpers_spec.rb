require 'spec_helper'
require_relative '../../../lib/howitzer/helpers'

describe "Helpers" do
  let(:settings) { double("settings")}
  describe "#selenium_driver?" do
    subject { selenium_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context "when :selenium" do
      let(:driver_setting) {:selenium}
      it{ expect(subject).to be_true }
    end
    context "when not :selenium" do
      let(:driver_setting) {:phantomjs}
      it{ expect(subject).to be_false }
    end
    context "when driver specified as String" do
      let(:driver_setting) {"selenium"}
      it{ expect(subject).to be_true }
    end
    context "when driver is not specified" do
      let(:driver_setting) { nil }
      it { expect {subject}.to raise_error(DriverNotSpecified, "Please check your settings") }
    end
  end
  describe "#ie_browser?" do
    subject { ie_browser? }
    before { allow(self).to receive(:sauce_driver?){ sauce_driver} }
    context "when sauce_driver? is TRUE" do
      let(:sauce_driver) { true }
      context "settings.sl_browser_name = :ie" do
        before { allow(settings).to receive(:sl_browser_name) { :ie } }
        it { expect(subject).to be_true }
      end
      context "settings.sl_browser_name = :iexplore" do
        before { allow(settings).to receive(:sl_browser_name) { :iexplore } }
        it { expect(subject).to be_true }
      end
      context "settings.sl_browser_name = :chrome" do
        before { allow(settings).to receive(:sl_browser_name) { :chrome } }
        it { expect(subject).to be_false }
      end
      context "settings.sl_browser_name is not specified" do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it { expect {subject}.to raise_error(SlBrowserNameNotSpecified, "Please check your settings") }
      end
    end
    context "when sauce_driver? is FALSE" do
      let(:sauce_driver) { false }
      before { allow(self).to receive(:selenium_driver?){ selenium_driver} }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :ie" do
          before { allow(settings).to receive(:sel_browser) { :ie } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :iexplore" do
          before { allow(settings).to receive(:sel_browser) { :iexplore } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it { expect {subject}.to raise_error(SelBrowserNotSpecified, "Please check your settings") }
        end
      end
      context "when selenium_driver? is FALSE" do
        let(:selenium_driver) { false }
        it { expect(subject).to be_false }
      end
    end
  end
end