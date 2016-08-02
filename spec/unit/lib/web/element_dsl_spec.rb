require 'spec_helper'
require 'howitzer/web/element_dsl'

RSpec.describe Howitzer::Web::ElementDsl do
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
  include_examples :capybara_context_holder
end
