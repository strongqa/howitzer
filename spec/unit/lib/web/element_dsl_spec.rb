require 'spec_helper'
require 'howitzer/web/element_dsl'

RSpec.describe Howitzer::Web::ElementDsl do
  let(:klass) do
    Class.new do
      include Howitzer::Web::ElementDsl
      def capybara_scopes
        @capybara_scopes ||= [Capybara.current_session]
      end
    end
  end
  let(:klass_object) { klass.new }

  it 'returns correct capybara context' do
    allow(Capybara).to receive(:current_session) { 'session' }
    expect(klass_object.capybara_context).to eq('session')
  end

  include_examples :element_dsl
  include_examples :capybara_context_holder
end
