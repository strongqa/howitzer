require 'spec_helper'
require 'howitzer/web/element_dsl'

RSpec.describe 'Element dsl for test class' do
  let(:klass) { Class.new { include Howitzer::Web::ElementDsl } }
  let(:klass_object) { klass.new }

  include_examples :element_dsl
end
