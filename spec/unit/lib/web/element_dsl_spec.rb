require 'spec_helper'
require 'howitzer/web/element_dsl'

RSpec.describe 'Element dsl for test class' do
  let(:klass) do
    Class.new do
      include Howitzer::Web::ElementDsl
      def capybara_context
        Capybara.current_session
      end
    end
  end
  let(:klass_object) { klass.new }

  include_examples :element_dsl
end
