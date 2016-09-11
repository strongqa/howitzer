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
        expect { subject }.to raise_error(Howitzer::InvalidApiKeyError, 'Api key can not be blank')
      end
    end
    context 'when api_key is blank string' do
      let(:key) { '' }
      subject { connector.client(key) }
      it do
        expect { subject }.to raise_error(Howitzer::InvalidApiKeyError, 'Api key can not be blank')
      end
    end
  end
  describe '#domain' do
    subject { connector.domain }
    context 'when default domain' do
      it do
        is_expected.to eq(Howitzer.mailgun_domain)
      end
    end
    context 'when domain is already set' do
      before do
        connector.domain = domain_name
      end
      it { is_expected.to eql(domain_name) }
    end
  end
end
