require 'spec_helper'
require 'howitzer/web'

RSpec.describe Howitzer::Web do
  context '.within_session' do
    it do
      expect(Howitzer::Web.current_session_name).to eq(:default)
      Howitzer::Web.within_session(:test_session) do
        expect(Howitzer::Web.current_session_name).to eq(:test_session)
      end
      expect(Howitzer::Web.current_session_name).to eq(:default)
    end
  end

  context '.current_session_name' do
    it { expect(Howitzer::Web.current_session_name).to eq(:default) }
  end

  context '.current_session_name=' do
    it do
      Howitzer::Web.current_session_name = :test_session
      expect(Howitzer::Web.current_session_name).to eq(:test_session)
    end
  end
end
