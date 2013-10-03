require 'spec_helper'
require "#{lib_path}/howitzer/web_page"
require "#{lib_path}/howitzer/utils/capybara_settings"


describe "WebPage" do
  describe ".open"
  describe ".given"
  describe "#tinymce_fill_in"
  describe "#click_alert_box"
  describe "#js_click"
  describe "#wait_for_ur"
  describe "#reload"
  #describe ".current_url" do
  #  let(:page) { double }
  #  let(:capybara) { double }
  #  let(:session) { double }
  #  let(:web) { Class.new }
  #  subject { WebPage.current_url }
  #  before do
  #    stub_const("URL_PATTERN", 'pattern')
  #    stub_const("Capybara", capybara)
  #    allow(capybara).to receive(:current_session)
  #    #allow(page).to receive(:current_url) { "google.com" }
  #  end
  #  it do
  #    expect(subject).to eq("ff")
  #  end
  #end
  describe ".text" do
    let(:other_instance) { WebPage.instance }
    before do
      allow(WebPage).to return
    end
    it { expect(WebPage.instance).to be eql(other_instance) }
  end
end