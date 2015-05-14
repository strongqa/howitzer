require 'spec_helper'

require 'howitzer/capybara/settings'

RSpec.describe 'CapybaraSettings' do
  it 'supports deprecated module name' do
    expect { CapybaraSettings }.to_not raise_error
    expect(CapybaraSettings).to eq(Capybara::Settings)
  end
end

RSpec.describe 'Capybara::Settings' do
  let(:log) { double('log') }
  let(:test_object) { double('test_object').extend(Capybara::Settings) }
  before do
    allow(log).to receive(:error).and_return( true )
  end

  describe '.base_ff_profile_settings' do
    subject { Capybara::Settings.base_ff_profile_settings }
    before do
      allow(::Selenium::WebDriver::Firefox::Profile).to receive(:new) { Hash.new }
      allow(settings).to receive(:app_host) { 'localhost' }
    end

    it do
      is_expected.to eq(
                         'network.http.phishy-userpass-length' => 255,
                         'browser.safebrowsing.malware.enabled' => false,
                         'network.automatic-ntlm-auth.allow-non-fqdn' => true,
                         'network.ntlm.send-lm-response' => true,
                         'network.automatic-ntlm-auth.trusted-uris' => 'localhost'
                     )
    end
  end

  describe '#sauce_resource_path' do
    subject { test_object.sauce_resource_path(name) }
    let (:name) { 'test_name' }
    before do
      allow(settings).to receive(:sl_user) { 'vlad' }
      allow(settings).to receive(:sl_api_key) { '11111' }
      allow(test_object).to receive(:session_id) { '12341234' }
    end
    it { is_expected.to eql('https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/test_name') }
  end
  describe '.sauce_resource_path' do
    subject { Capybara::Settings.sauce_resource_path(name) }
    let (:name) { 'test_name' }
    before  do
      allow(settings).to receive(:sl_user) { 'vlad' }
      allow(settings).to receive(:sl_api_key) { '11111' }
      allow(Capybara::Settings).to receive(:session_id) { '12341234' }
    end

    it { is_expected.to eql('https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/test_name') }
  end

  describe '#update_sauce_job_status' do
    subject { test_object.update_sauce_job_status }
    before  do
      allow(settings).to receive(:sl_user) { 'vlad1' }
      allow(settings).to receive(:sl_api_key) { '22222' }
      allow(test_object).to receive(:session_id) { '12341234' }
      stub_const('RestClient', double)
    end

    it do
      expect(RestClient).to receive(:put).with('http://vlad1:22222@saucelabs.com/rest/v1/vlad1/jobs/12341234', '{}', {content_type: :json, accept: :json}).once
      subject
    end
  end

  describe '.update_sauce_resource_path' do
    subject { Capybara::Settings.update_sauce_job_status }
    before  do
      allow(settings).to receive(:sl_user) { 'vlad1' }
      allow(settings).to receive(:sl_api_key) { '22222' }
      allow(Capybara::Settings).to receive(:session_id) { '12341234' }
      stub_const('RestClient', double)
    end

    it do
      expect(RestClient).to receive(:put).with('http://vlad1:22222@saucelabs.com/rest/v1/vlad1/jobs/12341234', '{}', {content_type: :json, accept: :json}).once
      subject
    end
  end

  describe '#suite_name' do
    subject { test_object.suite_name }
    before do
      allow(settings).to receive(:sl_browser_name) { 'ie' }
    end

    context 'when environment present' do
      before { ENV['RAKE_TASK'] = rake_task }
      context 'when includes rspec' do
        let(:rake_task) { 'rspec:bvt' }
        it { is_expected.to eql('BVT IE')}
      end
      context 'when includes spec' do
        let(:rake_task) { 'spec:bvt' }
        it { is_expected.to eql('BVT IE')}
      end

      context 'when includes cucumber' do
        let(:rake_task) { 'cucumber:bvt' }
        it { is_expected.to eql('BVT IE')}
      end
      context 'when not includes rpsec and cucumber' do
        let(:rake_task) { 'unknown' }
        it { is_expected.to eql('UNKNOWN IE')}
      end
      context 'when includes only cucumber' do
        let(:rake_task) { 'cucumber' }
        it { is_expected.to eql('ALL IE')}
      end
    end
    context 'when environment empty' do
      before { ENV['RAKE_TASK'] = nil }
      it { is_expected.to eql('CUSTOM IE')}
    end
  end

  describe '.suite_name' do
    subject { Capybara::Settings.suite_name }
    before do
      allow(settings).to receive(:sl_browser_name) { 'ie' }
    end

    context 'when environment present' do
      before { ENV['RAKE_TASK'] = rake_task }
      context 'when includes rspec' do
        let(:rake_task) { 'rspec:bvt' }
        it { is_expected.to eql('BVT IE')}
      end
      context 'when includes spec' do
        let(:rake_task) { 'spec:bvt' }
        it { is_expected.to eql('BVT IE')}
      end

      context 'when includes cucumber' do
        let(:rake_task) { 'cucumber:bvt' }
        it { is_expected.to eql('BVT IE')}
      end
      context 'when not includes rpsec and cucumber' do
        let(:rake_task) { 'unknown' }
        it { is_expected.to eql('UNKNOWN IE')}
      end
      context 'when includes only cucumber' do
        let(:rake_task) { 'cucumber' }
        it { is_expected.to eql('ALL IE')}
      end
    end
    context 'when environment empty' do
      before { ENV['RAKE_TASK'] = nil }
      it { is_expected.to eql('CUSTOM IE')}
    end
  end

  describe '#session_id' do
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

    it { is_expected.to eql('test') }
  end

  describe '.session_id' do
    subject { Capybara::Settings.session_id }
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

    it { is_expected.to eql('test') }
  end
end