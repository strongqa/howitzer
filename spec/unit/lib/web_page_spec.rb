require 'spec_helper'
require "#{lib_path}/howitzer/web_page"
require "#{lib_path}/howitzer/utils/capybara_settings"


describe "WebPage" do
  describe ".open" do
    let(:url) { "google.com" }
    let(:retryable) { double }
    subject { WebPage.open(url) }
    before do
      allow(WebPage).to receive(:new) { WebPage }
    end
    it do
      expect(log).to receive(:info).with("Open WebPage page by 'google.com' url")
      expect(WebPage).to receive(:retryable) { retryable }
      expect(subject).to be_true
    end
  end
  describe ".given"
  describe "#tinymce_fill_in"
  describe "#click_alert_box"
  describe "#js_click"
  describe "#wait_for_url"

  describe "#reload" do
    let(:wait_for_url) { double }
    subject { WebPage.instance.reload }
    let(:visit) { double }
    let(:webpage) { double }
    before do
      allow(WebPage).to receive(:instance) { WebPage.new }
    end
    it do
      expect(log).to receive(:info) { "Reload 'google.com' " }
      expect(WebPage).to receive(:visit) { visit }
      expect(visit).to receive(:current_url) { "google.com" }
      expect(subject).to be_true
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