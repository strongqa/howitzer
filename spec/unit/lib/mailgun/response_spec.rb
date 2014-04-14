require 'spec_helper'
require "#{lib_path}/howitzer/mailgun/client"

describe Mailgun::Response do
  let(:body) { {foo: 'bar'}.to_json }
  let(:response) { double(:response, body: body, code: 201)}
  describe "#body" do
    subject { Mailgun::Response.new(response).body }
    it { expect(subject).to eq("{\"foo\":\"bar\"}")}
  end
  describe "#code" do
    subject { Mailgun::Response.new(response).code }
    it { expect(subject).to eq(201)}
  end
  describe "#to_h" do
    subject { Mailgun::Response.new(response).to_h }
    context "when possible parse body" do
      it { expect(subject).to eq({"foo"=>"bar"})}
    end
    context "when impossible parse body" do
      let(:body) { '123' }
      it { expect { subject }.to raise_error(Mailgun::ParseError, "757: unexpected token at '123'")}
    end
  end
end