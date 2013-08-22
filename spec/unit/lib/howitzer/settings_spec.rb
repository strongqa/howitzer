require 'spec_helper'
require 'sexy_settings'
require_relative '../../../../lib/howitzer/settings'

describe "Settings" do
  context "#settings" do
  subject { settings }
  it do
    expect(SexySettings::Base).to receive(:instance)
    subject
  end
  end
  context "SexySettings configuration" do
    subject { require_relative '../../../../lib/howitzer/settings' }
    context "@path_to_default_settings should return correct path" do
      it do
        expect(SexySettings.configure.path_to_default_settings).to eq('/home/h8machine/web/howitzer/config/default.yml')
        subject
      end
    end
    context "@path_to_custom_settings should return correct path" do
      it do
        expect(SexySettings.configure.path_to_custom_settings).to eq('/home/h8machine/web/howitzer/config/custom.yml')
        subject
      end
    end
  end
end