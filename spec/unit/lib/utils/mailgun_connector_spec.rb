require 'spec_helper'
require "#{lib_path}/howitzer/utils/mailgun_connector"
require 'mailgun'

describe MailgunConnector do
  let(:connector) { MailgunConnector.instance }
  let(:domain_name) { 'test@domain.com' }
  describe "#client" do
    subject { connector.client }
    context "when api_key is default" do
      context "when client is not initialized" do
        it { expect(subject).to be_an_instance_of Mailgun::Client }
      end
      context "when client is already initialized" do
        it do
          object_id = connector.client.object_id
          expect(subject.object_id).to eq(object_id)
        end
      end
    end
    context "when api_key is custom" do
      let(:key) { "some api key" }
      subject { connector.client(key) }
      it { expect(subject).to be_an_instance_of Mailgun::Client }
    end
    context "when api_key is nil" do
      let(:key) { nil }
      subject { connector.client(key) }
      it { expect { subject}.to raise_error(MailgunConnector::InvalidApiKeyError, "Api key can not be blank") }
    end
    context "when api_key is blank string" do
      let(:key) { "" }
      subject { connector.client(key) }
      it { expect { subject}.to raise_error(MailgunConnector::InvalidApiKeyError, "Api key can not be blank") }
    end
  end
  describe '#domain' do
    subject { connector.domain }
    context "when domain is not set" do
      before { connector.instance_variable_set(:@domain, nil)}
      it do
        expect(connector).to receive(:change_domain).once{ domain_name }
        expect(subject).to eq(domain_name)
      end
    end
    context "when domain is already set" do
      before do
        expect(connector).to receive(:change_domain).never
        connector.instance_variable_set(:@domain, domain_name)
      end
      it { expect(subject).to eql(domain_name) }
    end
  end

  describe '#change_domain' do
    context "when default" do
      before { connector.change_domain }
      it { expect(connector.instance_variable_get(:@domain)).to eq(settings.mailgun_domain)}
    end
    context "when custom" do
      before { connector.change_domain(domain_name) }
      it { expect(connector.instance_variable_get(:@domain)).to eq(domain_name) }
    end
  end
end