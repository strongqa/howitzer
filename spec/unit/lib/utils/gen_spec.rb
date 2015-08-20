require 'spec_helper'
require 'howitzer/utils/gen'

RSpec.describe 'DataGenerator' do
  describe 'Gen' do
    describe '.serial' do
      subject { Gen.serial }
      context 'received value should conform to template' do
        it { is_expected.to match /\d{9}\w{5}/ }
      end
    end

    describe '#serial' do
      subject { double.tap{ |s| s.extend(Gen)}.serial }
      context 'received value should conform to template' do
        it { is_expected.to match /\d{9}\w{5}/ }
      end
    end
  end
end
