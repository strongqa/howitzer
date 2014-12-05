require 'spec_helper'
require 'howitzer/mailgun/client'

RSpec.describe Mailgun::Client do
  let(:mg_obj) { Mailgun::Client.new('Fake-API-Key') }
  describe '.new' do
    subject { mg_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#get' do
    let(:query_string){ {'skip' => '10', 'limit' => '5'} }
    subject { mg_obj.get('test.com/bounces', query_string) }
    context 'when simulation of client' do
      before do
        expect(RestClient::Resource).to receive(:new).once { Mailgun::UnitClient::new('Fake-API-Key', 'api.mailgun.net', 'v2') }
      end
      it do
        expect(subject.body).to include('total_count')
        expect(subject.body).to include('items')
      end
    end
    context 'when real client' do
      let(:resource) { double }
      before do
        allow(resource).to receive('[]'){ resource }
        allow(resource).to receive(:get).and_raise(StandardError, '401 Unauthorized: Forbidden')
        allow(RestClient::Resource).to receive(:new) { resource }
      end
      it do
        expect(log).to receive(:error).with(Howitzer::CommunicationError, '401 Unauthorized: Forbidden').once.and_call_original
        expect { subject }.to raise_error(Howitzer::CommunicationError)
      end
    end
  end
end