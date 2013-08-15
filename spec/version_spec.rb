require "spec_helper"

describe 'Version' do
  it 'should contains VERSION constant with correct format' do
    Howitzer.constants.should include(:VERSION)
    Howitzer::VERSION.should match(/^\d+\.\d+\.\d+$/)
  end
end