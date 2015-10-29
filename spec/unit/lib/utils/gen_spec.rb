require 'spec_helper'
require 'howitzer/utils/gen'

RSpec.describe Gen do
  describe '.serial' do
    subject { described_class.serial }
    context 'received value should conform to template' do
      it { is_expected.to match /\d{9}\w{5}/ }
    end
  end
end
