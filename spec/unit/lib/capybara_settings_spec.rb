require 'spec_helper'

require "#{lib_path}/howitzer/utils/capybara_settings"

describe "CapybaraSettings" do
  let(:log) { double("log") }
  let(:test_object) { double("test_object").extend(CapybaraSettings) }
  before do
    allow(log).to receive(:error).and_return( true )
  end

 describe "#sauce_resource_path" do
    subject { test_object.sauce_resource_path(name) }
    let (:name) { "test_name" }
    before  do
      allow(settings).to receive(:sl_user) { "vlad" }
      allow(settings).to receive(:sl_api_key) { "11111" }
      allow(test_object).to receive(:session_id) { '12341234' }
    end

    it { expect(subject).to eql("https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/test_name") }
  end
  describe ".sauce_resource_path" do
    subject { CapybaraSettings.sauce_resource_path(name) }
    let (:name) { "test_name" }
    before  do
      allow(settings).to receive(:sl_user) { "vlad" }
      allow(settings).to receive(:sl_api_key) { "11111" }
      allow(CapybaraSettings).to receive(:session_id) { '12341234' }
    end

    it { expect(subject).to eql("https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/test_name") }
  end

  describe "#update_sauce_job_status" do
    subject { test_object.update_sauce_job_status }
    before  do
      allow(settings).to receive(:sl_user) { "vlad1" }
      allow(settings).to receive(:sl_api_key) { "22222" }
      allow(test_object).to receive(:session_id) { '12341234' }
      stub_const("RestClient", double)
    end

    it do
      expect(RestClient).to receive(:put).with("http://vlad1:22222@saucelabs.com/rest/v1/vlad1/jobs/12341234", "{}", {content_type: :json, accept: :json}).once
      subject
    end
  end

  describe ".update_sauce_resource_path" do
    subject { CapybaraSettings.update_sauce_job_status }
    before  do
      allow(settings).to receive(:sl_user) { "vlad1" }
      allow(settings).to receive(:sl_api_key) { "22222" }
      allow(CapybaraSettings).to receive(:session_id) { '12341234' }
      stub_const("RestClient", double)
    end

    it do
      expect(RestClient).to receive(:put).with("http://vlad1:22222@saucelabs.com/rest/v1/vlad1/jobs/12341234", "{}", {content_type: :json, accept: :json}).once
      subject
    end
  end

  describe "#suite_name" do
    subject { test_object.suite_name }
    before do
      allow(settings).to receive(:sl_browser_name) { 'ie' }
    end

    context "when environment present" do
      before { ENV['RAKE_TASK'] = rake_task }
      context "when includes rspec" do
        let(:rake_task) { 'rspec:bvt' }
        it { expect(subject).to eql("BVT IE")}
      end
      context "when includes spec" do
        let(:rake_task) { 'spec:bvt' }
        it { expect(subject).to eql("BVT IE")}
      end

      context "when includes cucumber" do
        let(:rake_task) { 'cucumber:bvt' }
        it { expect(subject).to eql("BVT IE")}
      end
      context "when not includes rpsec and cucumber" do
        let(:rake_task) { 'unknown' }
        it { expect(subject).to eql("UNKNOWN IE")}
      end
      context "when includes only cucumber" do
        let(:rake_task) { 'cucumber' }
        it { expect(subject).to eql("ALL IE")}
      end
    end
    context "when environment empty" do
      before { ENV['RAKE_TASK'] = nil }
      it { expect(subject).to eql("CUSTOM IE")}
    end
  end

  describe ".suite_name" do
    subject { CapybaraSettings.suite_name }
    before do
      allow(settings).to receive(:sl_browser_name) { 'ie' }
    end

    context "when environment present" do
      before { ENV['RAKE_TASK'] = rake_task }
      context "when includes rspec" do
        let(:rake_task) { 'rspec:bvt' }
        it { expect(subject).to eql("BVT IE")}
      end
      context "when includes spec" do
        let(:rake_task) { 'spec:bvt' }
        it { expect(subject).to eql("BVT IE")}
      end

      context "when includes cucumber" do
        let(:rake_task) { 'cucumber:bvt' }
        it { expect(subject).to eql("BVT IE")}
      end
      context "when not includes rpsec and cucumber" do
        let(:rake_task) { 'unknown' }
        it { expect(subject).to eql("UNKNOWN IE")}
      end
      context "when includes only cucumber" do
        let(:rake_task) { 'cucumber' }
        it { expect(subject).to eql("ALL IE")}
      end
    end
    context "when environment empty" do
      before { ENV['RAKE_TASK'] = nil }
      it { expect(subject).to eql("CUSTOM IE")}
    end
  end

  describe "#session_id" do
    subject { test_object.session_id }
    before do
      browser = double
      current_session = double
      driver = double
      instance_variable = double
      allow(Capybara).to receive(:current_session){current_session}
      allow(current_session).to receive(:driver){driver}
      allow(driver).to receive(:browser){browser}
      allow(browser).to receive(:instance_variable_get).with(:@bridge){ instance_variable }
      allow(instance_variable).to receive(:session_id){ 'test'}
    end

    it { expect(subject).to eql('test') }
  end

  describe ".session_id" do
    subject { CapybaraSettings.session_id }
    before do
      browser = double
      current_session = double
      driver = double
      instance_variable = double
      allow(Capybara).to receive(:current_session){current_session}
      allow(current_session).to receive(:driver){driver}
      allow(driver).to receive(:browser){browser}
      allow(browser).to receive(:instance_variable_get).with(:@bridge){ instance_variable }
      allow(instance_variable).to receive(:session_id){ 'test'}
    end

    it { expect(subject).to eql('test') }
  end
  describe "#define_selenium_driver" do
    context "when correct parameters" do
      before do
        allow(settings).to receive(:sel_browser) { "selenium" }
      end
      subject { CapybaraSettings.send :define_selenium_driver }

      it { true }
    end
  end
end
