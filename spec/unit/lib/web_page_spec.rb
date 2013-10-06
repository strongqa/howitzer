require 'spec_helper'
require "#{lib_path}/howitzer/web_page"
require "#{lib_path}/howitzer/utils/capybara_settings"


describe "WebPage" do
  describe ".open" do
    let(:url_value) { "google.com" }
    let(:retryable) { double }
    let(:wait_for_url) { double }
    let(:other_instance) { WebPage.instance }
    subject { WebPage.open(url_value) }
    before do
      stub_const("WebPage::URL_PATTERN", 'pattern')
      allow(WebPage.instance).to receive(:wait_for_url).with('pattern') { true }
    end
    it do
      expect(log).to receive(:info).with("Open WebPage page by 'google.com' url")
      expect(WebPage).to receive(:retryable) { retryable }
      expect(subject).to eq(other_instance)
      subject
    end
  end

  describe ".given" do
    let(:wait_for_url) { double }
    before do
      stub_const("WebPage::URL_PATTERN",'pattern')
      allow(WebPage.instance).to receive(:wait_for_url).with('pattern') { true }
    end
    it do
      expect(WebPage.given).to be_a_kind_of(WebPage)
    end
  end

  describe "#tinymce_fill_in" do
    subject { WebPage.instance.tinymce_fill_in(name,options) }
    let(:name) { 'name' }
    let(:options) { {with: "some content"} }
    before do
      allow(WebPage.instance).to receive(:current_url) { "google.com" }
      allow(settings).to receive(:driver) { driver_name }
    end
    context "when correct driver specified" do
      let(:driver_name) { 'selenium' }
      let(:page) { double }
      let(:driver) { double }
      let(:browser) { double }
      let(:switch_to) { double }
      let(:find) { double }
      let(:native) { double }
      it do
        expect(WebPage.instance).to receive(:page).exactly(3).times { page }
        expect(page).to receive(:driver) { driver }
        expect(driver).to receive(:browser) { browser }
        expect(browser).to receive(:switch_to) { switch_to }
        expect(switch_to).to receive(:frame).with("name_ifr")

        expect(page).to receive(:find).with(:css, '#tinymce') { find }
        expect(find).to receive(:native) { native }
        expect(native).to receive(:send_keys).with("some content")

        expect(page).to receive(:driver) { driver }
        expect(driver).to receive(:browser) { browser }
        expect(browser).to receive(:switch_to) { switch_to }
        expect(switch_to).to receive(:default_content)

        subject
      end
    end
    context "when incorrect driver specified" do
      let(:driver_name) { 'ff' }
      let(:page) { double }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:execute_script).with("tinyMCE.get('name').setContent('some content')")
        subject
      end
    end
  end
  describe "#click_alert_box" do
    subject { WebPage.instance.click_alert_box(flag_value) }
    before do
      allow(settings).to receive(:driver) { driver_name }
      allow(settings).to receive(:timeout_tiny) { 0 }
      allow(WebPage.instance).to receive(:current_url) { "google.com" }
    end
    context "when flag true and correct driver specified" do
      let(:flag_value) { true }
      let(:page) { double }
      let(:alert) { double }
      let(:driver) { double }
      let(:browser) { double }
      let(:switch_to) { double }
      let(:driver_name) { 'selenium' }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:driver) { driver }
        expect(driver).to receive(:browser) { browser }
        expect(browser).to receive(:switch_to) { switch_to }
        expect(switch_to).to receive(:alert) { alert }
        expect(alert).to receive(:accept)
        subject
      end
    end
    context "when flag false and correct driver specified" do
      let(:flag_value) { false }
      let(:page) { double }
      let(:alert) { double }
      let(:driver) { double }
      let(:browser) { double }
      let(:switch_to) { double }
      let(:driver_name) { 'selenium' }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:driver) { driver }
        expect(driver).to receive(:browser) { browser }
        expect(browser).to receive(:switch_to) { switch_to }
        expect(switch_to).to receive(:alert) { alert }
        expect(alert).to receive(:dismiss)
        subject
      end
    end
    context "when flag true and wrong driver specified" do
      let(:flag_value) { true }
      let(:page) { double }
      let(:driver_name) { 'ff' }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:evaluate_script).with('window.confirm = function() { return true; }')
        subject
      end
    end
    context "when flag false and wrong driver specified" do
      let(:driver_name) { 'ff' }
      let(:flag_value) { false }
      let(:page) { double }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:evaluate_script).with('window.confirm = function() { return false; }')
        subject
      end
    end
  end

  describe "#js_click" do
    subject { WebPage.instance.js_click(".some_class") }
    before do
      allow(settings).to receive(:timeout_tiny) { 0.1 }
      allow(WebPage.instance).to receive(:current_url) { "google.com" }
    end
    let(:page) { double }
    it do
      expect(WebPage.instance).to receive(:page) { page }
      expect(page).to receive(:execute_script).with("$('.some_class').trigger('click')")
      subject
    end

  end
  describe "#wait_for_url" do
    subject { WebPage.instance.wait_for_url(expected_url) }
    before do
      allow(settings).to receive(:timeout_small) { 0.1 }
      allow(WebPage.instance).to receive(:current_url) { "google.com" }
    end
    context "when current_url equals expected_url" do
      let(:expected_url) { "google.com" }
      it { expect(subject).to be_true }
    end
    context "when current_url not equals expected_url" do
      let(:expected_url) { "bad_url" }
      let(:error) { WebPage::IncorrectPageError }
      let(:error_message) { "Current url: google.com, expected:  #{expected_url}"  }
      it { expect{subject}.to raise_error(error, error_message) }
    end
  end

  describe "#reload" do
    let(:wait_for_url) { double }
    subject { WebPage.instance.reload }
    let(:visit) { double }
    let(:webpage) { double }
    before do
      allow(WebPage.instance).to receive(:current_url) { "google.com" }
      stub_const("WebPage::URL_PATTERN",'pattern')
      allow(wait_for_url).to receive('pattern').and_return { true }
    end
    it do
      expect(log).to receive(:info) { "Reload 'google.com' " }
      expect(WebPage.instance).to receive(:visit).with("google.com")
      subject
    end
  end

  describe ".current_url" do
    let(:page) { double }
    subject { WebPage.current_url }
    it do
      expect(WebPage).to receive(:page) { page }
      expect(page).to receive(:current_url) { "google.com" }
      expect(subject).to eq("google.com")
    end
  end

  describe ".text" do
    let(:page) { double }
    let(:find) { double }
    subject { WebPage.text }
    it do
      expect(WebPage).to receive(:page) { page }
      expect(page).to receive(:find).with('body') { find }
      expect(find).to receive(:text) { "some body text" }
      expect(subject).to eq("some body text")
    end
  end
end