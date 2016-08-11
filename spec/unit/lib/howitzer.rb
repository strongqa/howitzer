require 'spec_helper'
require 'howitzer'

RSpec.describe 'Howitzer' do
  describe '.settings' do
    subject { Howitzer.settings }
    context 'when method called two times' do
      let(:other_settings) { Howitzer.settings }
      it { is_expected.to equal(other_settings) }
      it { expect(other_settings).to be_a_kind_of(SexySettings::Base) }
    end
  end
  describe 'SexySettings configuration' do
    subject { SexySettings.configuration }
    it { expect(subject.path_to_custom_settings).to include('config/custom.yml') }
    it { expect(subject.path_to_default_settings).to include('config/default.yml') }
  end
  describe '.app_uri' do
    before do
      allow(settings).to receive(:app_base_auth_login) { app_base_auth_login_setting }
      allow(settings).to receive(:app_base_auth_pass) { app_base_auth_pass_setting }
      allow(settings).to receive(:app_protocol) { app_protocol_setting }
      allow(settings).to receive(:app_host) { app_host_setting }
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
  end
end
