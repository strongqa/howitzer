require 'spec_helper'
require 'howitzer/web/element_dsl'

RSpec.describe Howitzer::Web::SectionDsl do
  let(:web_page_class) do
    Class.new do
      include Howitzer::Web::SectionDsl
    end
  end
end
