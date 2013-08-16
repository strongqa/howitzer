require "spec_helper"

describe Howitzer do
  it { expect(subject.constants).to include(:VERSION) }
  it 'should contains VERSION constant with correct format' do
    expect(Howitzer::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end