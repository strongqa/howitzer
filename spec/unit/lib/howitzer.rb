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
  end
end
