require 'spec_helper'
require 'howitzer/web/anonymous_section'

RSpec.describe Howitzer::Web::AnonymousSection do
  describe 'DSL' do
    describe '.me' do
      it { expect { described_class.send(:me, '.foo') }.to raise_error(NoMethodError) }
    end
  end

  describe '.default_finder_args' do
    subject { described_class.default_finder_args }
    it { is_expected.to be_nil }
  end

  describe '#parent' do
    subject { described_class.new(:test, 1).parent }
    it { is_expected.to eq(:test) }
  end

  describe '#context' do
    subject { described_class.new(1, :test).context }
    it { is_expected.to eq(:test) }
  end
end
