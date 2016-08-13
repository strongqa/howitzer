require 'spec_helper'
require 'howitzer/mailgun_api/connector'

RSpec.describe Howitzer::MailgunApi::Connector do
  let(:connector) { described_class.instance }
  let(:domain_name) { 'test@domain.com' }
  describe '#client' do
    subject { connector.client }
    context 'when api_key is default' do
      context 'when client is not initialized' do
        it { is_expected.to be_an_instance_of Howitzer::MailgunApi::Client }
      end
      context 'when client is already initialized' do
        it do
          object_id = connector.client.object_id
          expect(subject.object_id).to eq(object_id)
        end
      end
    end
    context 'when api_key is custom' do
      let(:key) { 'some api key' }
      subject { connector.client(key) }
      it { is_expected.to be_an_instance_of Howitzer::MailgunApi::Client }
    end
    context 'when api_key is nil' do
      let(:key) { nil }
      subject { connector.client(key) }
      it do
        expect(log).to receive(:error).with(Howitzer::InvalidApiKeyError, 'Api key can not be blank')
          .once.and_call_original
        expect { subject }.to raise_error(Howitzer::InvalidApiKeyError)
      end
    end
    context 'when api_key is blank string' do
      let(:key) { '' }
      subject { connector.client(key) }
      it do
        expect(log).to receive(:error).with(Howitzer::InvalidApiKeyError, 'Api key can not be blank')
          .once.and_call_original
        expect { subject }.to raise_error(Howitzer::InvalidApiKeyError)
      end
    end
  end
  describe '#domain' do
    subject { connector.domain }
    context 'when domain is not set' do
      before { connector.instance_variable_set(:@domain, nil) }
      it do
        expect(connector).to receive(:change_domain).once { domain_name }
        is_expected.to eq(domain_name)
      end
    end
    context 'when domain is already set' do
      before do
        expect(connector).to receive(:change_domain).never
        connector.instance_variable_set(:@domain, domain_name)
      end
      it { is_expected.to eql(domain_name) }
    end
  end

  describe '#change_domain' do
    context 'when default' do
      before { connector.change_domain }
      it { expect(connector.instance_variable_get(:@domain)).to eq(Howitzer.mailgun_domain) }
    end
    context 'when custom' do
      before { connector.change_domain(domain_name) }
      it { expect(connector.instance_variable_get(:@domain)).to eq(domain_name) }
    end
  end
end
