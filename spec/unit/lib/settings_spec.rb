require 'spec_helper'

describe 'Settings' do
  context '#settings' do
    subject { settings }
    context 'when method called two times' do
      let(:other_settings) { settings }
      it { is_expected.to equal(other_settings) }
      it { expect(other_settings).to be_a_kind_of(SexySettings::Base) }
    end
  end
  context 'SexySettings configuration' do
    subject { SexySettings.configuration }
    it { expect(subject.path_to_custom_settings).to include('config/custom.yml') }
    it { expect(subject.path_to_default_settings).to include('config/default.yml') }
  end
end