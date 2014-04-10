require 'spec_helper'
require "#{lib_path}/howitzer/utils/mailgun_connector"
require 'mailgun'

describe MailgunConnector do
  let(:connector_instance) { MailgunConnector.instance }

  describe "#client" do
    subject { connector_instance.client }
    context "when api_key is default" do
      before do
        allow(settings).to receive(:mailgun_key)
      end
      it { expect(subject).to be_an_instance_of Mailgun::Client }
    end

    context "when api_key is custom" do
      let(:key) { double }
      subject { connector_instance.client(key) }
      it { expect(subject).to be_an_instance_of Mailgun::Client }
    end

    context "when api_key in absent in settings" do
    end
  end

  describe '#domain' do
  end

  describe '#change_domain' do
  end
end