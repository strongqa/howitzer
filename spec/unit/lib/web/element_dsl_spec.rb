require 'spec_helper'
require 'howitzer/web/element_dsl'

RSpec.describe Howitzer::Web::ElementDsl do
  let(:klass) do
    Class.new do
      include Howitzer::Web::ElementDsl
      def capybara_scopes
        @capybara_scopes ||= Hash.new { |hash, key| hash[key] = [Capybara.current_session] }
        @capybara_scopes[Howitzer.session_name]
      end
    end
  end
  let(:klass_object) { klass.new }

  it 'returns correct capybara context' do
    allow(Capybara).to receive(:current_session) { 'session' }
    expect(klass_object.capybara_context).to eq('session')
  end

  it 'returns another capybara context' do
    allow(Capybara).to receive(:current_session) { 'session' }
    expect(klass_object.capybara_context).to eq('session')
    Howitzer.session_name = 'session2'
    allow(Capybara).to receive(:current_session) { 'session2' }
    expect(klass_object.capybara_context).to eq('session2')
  end

  include_examples :element_dsl
  include_examples :capybara_context_holder
end
