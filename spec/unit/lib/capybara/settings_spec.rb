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

  describe '.define_driver' do
    subject { Capybara::Settings.define_driver }
    context 'when selenium driver' do
      before do
        allow(settings).to receive(:driver).and_return('selenium')
        allow(settings).to receive(:sel_browser).and_return('chrome')
        allow(Capybara::Settings).to receive(:ff_browser?).and_return(false)
      end
      it do
        expect(Capybara.default_driver).to be(:selenium)
        expect(subject.call).to be_an_instance_of(Capybara::Selenium::Driver)
      end
    end

    context 'when selenium dev driver' do
      let(:profile) { Hash.new }
      before do
        allow(::Selenium::WebDriver::Firefox::Profile).to receive(:new) { profile }
        allow(settings).to receive(:app_host) { 'localhost' }
        allow(settings).to receive(:driver).and_return('selenium_dev')
        allow(settings).to receive(:sel_browser).and_return('firefox')
      end

      context 'when extension is found' do
        before { allow(profile).to receive(:add_extension).and_return('') }
        it do
          expect(Capybara.default_driver).to be(:selenium)
          expect(subject.call).to be_an_instance_of(Capybara::Selenium::Driver)
        end
        it do
          expect(subject.call.options[:profile]).to eq(
                                                        'network.http.phishy-userpass-length' => 255,
                                                        'browser.safebrowsing.malware.enabled' => false,
                                                        'network.automatic-ntlm-auth.allow-non-fqdn' => true,
                                                        'network.ntlm.send-lm-response' => true,
                                                        'network.automatic-ntlm-auth.trusted-uris' => 'localhost',
                                                        'extensions.firebug.currentVersion' => 'Last',
                                                        'extensions.firebug.previousPlacement' => 1,
                                                        'extensions.firebug.onByDefault' => true,
                                                        'extensions.firebug.defaultPanelName' => 'firepath',
                                                        'extensions.firebug.script.enableSites' => true,
                                                        'extensions.firebug.net.enableSites' => true,
                                                        'extensions.firebug.console.enableSites' => true
                                                    )
        end
      end
    end

    context 'when webkit driver' do
      before do
        allow(settings).to receive(:driver).and_return('webkit')
        allow(Capybara::Settings).to receive(:require).with('capybara-webkit').and_return(true)
      end
      it { is_expected.to be true }
    end

    context 'when poltergeist driver' do
      before do
        allow(settings).to receive(:driver).and_return('poltergeist')
        allow(settings).to receive(:pjs_ignore_js_errors).and_return(false)
      end
      it do
        expect(subject.call).to be_an_instance_of(Capybara::Poltergeist::Driver)
        expect(subject.call.options).to eq(
                                            js_errors: !settings.pjs_ignore_js_errors,
                                            phantomjs_options: ['--ignore-ssl-errors=no']
                                        )
      end
    end

    context 'when phantomjs driver' do
      before do
        allow(settings).to receive(:driver).and_return('phantomjs')
        allow(settings).to receive(:pjs_ignore_js_errors).and_return(false)
      end
      it do
        expect(subject.call).to be_an_instance_of(Capybara::Selenium::Driver)
        expect(subject.call.options[:browser]).to eq(:phantomjs)
        expect(subject.call.options[:desired_capabilities][:javascript_enabled]).not_to eq(settings.pjs_ignore_js_errors)
        expect(subject.call.options[:args]).to eq(["--ignore-ssl-errors=no"])
      end
    end

    context 'when sauce driver' do
      let(:driver) { Object.new }
      before do
        allow(settings).to receive(:driver).and_return('sauce')
        allow(settings).to receive(:sl_browser_name).and_return('firefox')
        allow(driver).to receive_message_chain(:browser, :file_detector=)
        allow(Capybara::Selenium::Driver).to receive(:new).and_return(driver)
      end
      it { expect(subject.call).to eql(driver) }
    end

    context 'when testingbot driver' do
      let(:driver) { Object.new }
      before do
        allow(settings).to receive(:driver).and_return('testingbot')
        allow(settings).to receive(:tb_browser_name).and_return('firefox')
        allow(driver).to receive_message_chain(:browser, :file_detector=)
        allow(Capybara::Selenium::Driver).to receive(:new).and_return(driver)
      end
      it { expect(subject.call).to eql(driver) }
    end

    context 'when selenium_grid driver' do
      before { allow(settings).to receive(:driver).and_return('selenium_grid') }

      context "and ie browser" do
        before { allow(Capybara::Settings).to receive(:ie_browser?).and_return(true) }
        it do
          expect(subject.call).to be_an_instance_of(Capybara::Selenium::Driver)
          expect(subject.call.options[:desired_capabilities][:browser_name]).to eq('internet explorer')
          expect(subject.call.options[:desired_capabilities][:platform]).to eq(:windows)
        end
      end

      context "and firefox browser" do
        before do
          allow(Capybara::Settings).to receive(:ie_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:ff_browser?).and_return(true)
        end
        it do
          expect(subject.call).to be_an_instance_of(Capybara::Selenium::Driver)
          expect(subject.call.options[:desired_capabilities][:browser_name]).to eq('firefox')
        end
      end

      context "and chrome browser" do
        before do
          allow(Capybara::Settings).to receive(:ie_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:ff_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:chrome_browser?).and_return(true)
        end
        it do
          expect(subject.call).to be_an_instance_of(Capybara::Selenium::Driver)
          expect(subject.call.options[:desired_capabilities][:browser_name]).to eq('chrome')
        end
      end

      context "and safari browser" do
        before do
          allow(Capybara::Settings).to receive(:ie_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:ff_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:chrome_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:safari_browser?).and_return(true)
        end
        it do
          expect(subject.call).to be_an_instance_of(Capybara::Selenium::Driver)
          expect(subject.call.options[:desired_capabilities][:browser_name]).to eq('safari')
        end
      end

      context "and incorrect browser" do
        before do
          allow(Capybara::Settings).to receive(:ie_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:ff_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:chrome_browser?).and_return(false)
          allow(Capybara::Settings).to receive(:safari_browser?).and_return(false)
          it do
            expect { subject }.to raise_error(RuntimeError, "Unknown '#{settings.sel_browser}' sel_browser. Check your settings, it should be one of [:ie, :iexplore, :ff, :firefox, :chrome, safari]")
          end
        end
      end
    end

    context 'when browserstack driver' do
      let(:driver) { Object.new }
      before do
        allow(settings).to receive(:driver).and_return('browserstack')
        allow(settings).to receive(:bs_browser_name).and_return('firefox')
        allow(driver).to receive_message_chain(:browser, :file_detector=)
        allow(Capybara::Selenium::Driver).to receive(:new).and_return(driver)
      end
      it { expect(subject.call).to eql(driver) }
    end

    context 'when incorrect driver' do
      before do
        allow(settings).to receive(:driver).and_return('caramba')
      end
      it do
        expect { subject }.to raise_error(RuntimeError, "Unknown '#{settings.driver}' driver. Check your settings, it should be one of [selenium, selenium_grid, selenium_dev, webkit, poltergeist, phantomjs, sauce, testingbot, browserstack]")
      end
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

  describe '#rake_task_name' do
    subject { test_object.rake_task_name }
    before { ENV['RAKE_TASK'] = rake_task }
    context 'when includes rspec' do
      let(:rake_task) { 'rspec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes cucumber' do
      let(:rake_task) { 'cucumber:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes spec' do
      let(:rake_task) { 'spec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes only cucumber' do
      let(:rake_task) { 'cucumber' }
      it { is_expected.to eq('') }
    end
    context 'when includes unknown task' do
      let(:rake_task) { 'unknown' }
      it { is_expected.to eq('UNKNOWN') }
    end
    context 'when environment is empty' do
      let(:rake_task) { nil }
      it { is_expected.to eq('') }
    end
  end

  describe '.rake_task_name' do
    subject { Capybara::Settings.rake_task_name }
    before { ENV['RAKE_TASK'] = rake_task }
    context 'when includes rspec' do
      let(:rake_task) { 'rspec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes cucumber' do
      let(:rake_task) { 'cucumber:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes spec' do
      let(:rake_task) { 'spec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes only cucumber' do
      let(:rake_task) { 'cucumber' }
      it { is_expected.to eq('') }
    end
    context 'when includes unknown task' do
      let(:rake_task) { 'unknown' }
      it { is_expected.to eq('UNKNOWN') }
    end
    context 'when environment is empty' do
      let(:rake_task) { nil }
      it { is_expected.to eq('') }
    end
  end
end