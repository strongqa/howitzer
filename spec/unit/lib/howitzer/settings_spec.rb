require 'spec_helper'
require_relative '../../../../lib/howitzer/settings'

describe "Settings" do
  context "#settings" do
    subject { settings }
    context "when method called two times" do
      let(:obj1) { subject }
      let(:obj2) { subject }
      it { expect(obj1).to equal(obj2) }
      it { expect(obj1).to be_a_kind_of(SexySettings::Base) }
    end
  end
  context "SexySettings configuration" do
    subject { SexySettings.configure }
    context "@path_to_default_settings should return correct path" do
      it do
        expect(SexySettings.configure.path_to_default_settings).to include('config/default.yml')
        subject
      end
    end
    context "@path_to_custom_settings should return correct path" do
      it do
        expect(SexySettings.configure.path_to_custom_settings).to include('config/default.yml')
        subject
      end
    end
  end
end