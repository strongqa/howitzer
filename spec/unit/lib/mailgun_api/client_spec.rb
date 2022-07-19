require 'spec_helper'
require 'howitzer/mailgun_api/client'

RSpec.describe Howitzer::MailgunApi::Client do
  let(:mg_obj) { described_class.new(api_key: 'Fake-API-Key') }
  let(:bounce_msg) do
    JSON.generate(
      'total_count' => 1,
      'items' => {
        'created_at' => 'Fri, 21 Oct 2011 11:02:55 GMT',
        'code' => 550,
        'address' => 'baz@example.com',
        'error' => 'Message was not accepted -- invalid mailbox. Local mailbox baz@example.com is" +
                           " unavailable: user not found'
      }
    )
  end
  let(:message) do
    {
      'body-plain' => 'test body footer',
      'stripped-html' => '<p> test body </p> <p> footer </p>',
      'stripped-text' => 'test body',
      'From' => 'Strong Tester <tester@gmail.com>',
      'To' => 'baz@example.com',
      'Received' => 'by 10.216.46.75 with HTTP; Sat, 5 Apr 2014 05:10:42 -0700 (PDT)',
      'sender' => 'tester@gmail.com',
      'attachments' => []
    }
  end
  describe '.new' do
    subject { mg_obj }
    it { expect { subject }.not_to raise_error }
  end

  describe '#get' do
    let(:query_string) { { 'skip' => '10', 'limit' => '5' } }
    subject { mg_obj.get('test.com/bounces', params: query_string) }
    context 'when simulation of client' do
      before do
        FakeWeb.register_uri(:get, 'https://api:Fake-API-Key@api.mailgun.net/v3/test.com/' \
                                   'bounces?skip=10&limit=5', body: bounce_msg.to_s)
      end
      it do
        expect(subject.body).to include('total_count')
        expect(subject.body).to include('items')
      end
    end
    context 'when real client' do
      let(:resource) { double }
      before do
        allow(resource).to receive('[]').and_return(resource)
        allow(resource).to receive(:get).and_raise(StandardError, '401 Unauthorized: Forbidden')
        allow(RestClient::Resource).to receive(:new).and_return(resource)
      end
      it do
        expect { subject }.to raise_error(Howitzer::CommunicationError, '401 Unauthorized: Forbidden')
      end
    end
  end

  describe '#get_url' do
    let(:response_raw) { double }
    before do
      FakeWeb.register_uri(:any, 'https://api:Fake-API-Key@ci.api.mailgan.com/' \
                                 'domains/test_domain/messages/asdfasdf', body: JSON.generate(message))
    end
    subject { mg_obj.get_url('https://ci.api.mailgan.com/domains/test_domain/messages/asdfasdf') }
    context 'when success request' do
      it { expect(subject.to_h).to eq(message) }
    end
    context 'when error happens' do
      before do
        allow(RestClient::Resource).to receive(:new).with(any_args).and_return(response_raw)
        mg_obj
        allow(RestClient::Request).to receive(:execute).with(any_args).and_raise(StandardError, 'Some message')
      end
      it { expect { subject }.to raise_error(Howitzer::CommunicationError, 'Some message') }
    end
  end
end
