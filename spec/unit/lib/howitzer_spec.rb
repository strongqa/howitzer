require 'spec_helper'
require 'howitzer'

RSpec.describe 'Howitzer' do
  describe 'SexySettings configuration' do
    subject { SexySettings.configuration }
    it { expect(subject.path_to_custom_settings).to include('config/custom.yml') }
    it { expect(subject.path_to_default_settings).to include('config/default.yml') }
  end
  describe '.app_uri' do
    before do
      allow(Howitzer).to receive(:app_base_auth_login) { app_base_auth_login_setting }
      allow(Howitzer).to receive(:app_base_auth_pass) { app_base_auth_pass_setting }
      allow(Howitzer).to receive(:app_protocol) { app_protocol_setting }
      allow(Howitzer).to receive(:app_host) { app_host_setting }
    end
    let(:app_protocol_setting) { nil }
    let(:app_host_setting) { 'redmine.strongqa.com' }
    context 'when login and password present' do
      let(:app_base_auth_login_setting) { 'alex' }
      let(:app_base_auth_pass_setting) { 'pa$$w0rd' }
      it { expect(Howitzer.app_uri.site).to eq('http://alex:pa$$w0rd@redmine.strongqa.com') }
      it { expect(Howitzer.app_uri.origin).to eq('http://redmine.strongqa.com') }
    end
    context 'when login and password blank' do
      let(:app_base_auth_login_setting) { nil }
      let(:app_base_auth_pass_setting) { nil }
      it { expect(Howitzer.app_uri.site).to eq('http://redmine.strongqa.com') }
    end
    context 'when custom host exist' do
      before do
        allow(Howitzer).to receive(:test_app_base_auth_login) { app_base_auth_login_setting }
        allow(Howitzer).to receive(:test_app_base_auth_pass) { app_base_auth_pass_setting }
        allow(Howitzer).to receive(:test_app_protocol) { app_protocol_setting }
        allow(Howitzer).to receive(:test_app_host) { app_host_setting }
      end
      let(:app_host_setting) { 'test.strongqa.com' }
      let(:app_protocol_setting) { nil }
      context 'when login and password present' do
        let(:app_base_auth_login_setting) { 'user' }
        let(:app_base_auth_pass_setting) { 'password' }
        it { expect(Howitzer.app_uri(:test).site).to eq('http://user:password@test.strongqa.com') }
      end
      context 'when login and password blank' do
        let(:app_base_auth_login_setting) { nil }
        let(:app_base_auth_pass_setting) { nil }
        it { expect(Howitzer.app_uri(:test).site).to eq('http://test.strongqa.com') }
      end
    end
    context 'when configuration settings are not specified for particular application' do
      it do
        expect { Howitzer.app_uri(:test).site }.to raise_error(
          Howitzer::UndefinedSexySettingError,
          "Undefined 'test_app_base_auth_login' setting. Please add the setting to config/default.yml:\n " \
          "test_app_base_auth_login: some_value\n"
        )
      end
    end
  end
  describe '.mailgun_idle_timeout' do
    subject { Howitzer.mailgun_idle_timeout }
    before do
      expect_any_instance_of(Object).to receive(:puts).with(
        "WARNING! 'mailgun_idle_timeout' setting is deprecated. Please replace with 'mail_wait_time' setting."
      )
    end
    it { is_expected.to be_nil }
  end
  describe '.session_name' do
    context 'when default' do
      subject { Howitzer.session_name }
      it do
        is_expected.to be_eql('default')
      end
    end
    context 'when set' do
      subject { Howitzer.session_name = 'another' }
      it do
        expect(Capybara).to receive(:session_name=).with('another')
        is_expected.to be_eql('another')
      end
    end
  end
  describe 'using_session' do
    before { Howitzer.session_name = 'default' }
    it do
      expect(Capybara).to receive(:using_session).with('another')
      Howitzer.using_session('another') { nil }
      expect(Howitzer.session_name).to be_eql('default')
    end
  end
end
