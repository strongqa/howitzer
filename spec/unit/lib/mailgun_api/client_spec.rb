require 'spec_helper'
require 'howitzer/mailgun_api/client'

RSpec.describe Howitzer::MailgunApi::Client do
  let(:mg_obj) { described_class.new(api_key: 'Fake-API-Key') }
  describe '.new' do
    subject { mg_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#get' do
    let(:query_string) { { 'skip' => '10', 'limit' => '5' } }
    subject { mg_obj.get('test.com/bounces', params: query_string) }
    context 'when simulation of client' do
      before do
        expect(RestClient::Resource).to receive(:new)
          .once { Howitzer::MailgunApi::UnitClient.new('Fake-API-Key', 'api.mailgun.net', 'v2') }
      end
      it do
        expect(subject.body).to include('total_count')
        expect(subject.body).to include('items')
      end
    end
    context 'when real client' do
      let(:resource) { double }
      before do
        allow(resource).to receive('[]') { resource }
        allow(resource).to receive(:get).and_raise(StandardError, '401 Unauthorized: Forbidden')
        allow(RestClient::Resource).to receive(:new) { resource }
      end
      it do
        expect(log).to receive(:error).with(Howitzer::CommunicationError, '401 Unauthorized: Forbidden')
          .once.and_call_original
        expect { subject }.to raise_error(Howitzer::CommunicationError)
      end
    end
  end

  describe '#get_url' do
    let(:response_raw) { double }
    subject { mg_obj.get_url('https://ci.api.mailgan.com/domains/test_domain/messages/asdfasdf') }
    context 'when success request' do
      let(:response_raw) { double }
      let(:response_real) { double }
      before do
        allow(RestClient::Resource).to receive(:new).with(any_args) { response_raw }
        allow(Howitzer::MailgunApi::Response).to receive(:new).with(response_raw) { response_real }
      end
      it { is_expected.to eq(response_real) }
    end
    context 'when error happens' do
      before do
        allow(RestClient::Resource).to receive(:new).with(any_args) { response_raw }
        mg_obj
        allow(RestClient::Resource).to receive(:new).with(any_args).and_raise(StandardError, 'Some message')
      end
      it { expect { subject }.to raise_error(Howitzer::CommunicationError, 'Some message') }
    end
  end
end
