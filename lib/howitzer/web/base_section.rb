require 'howitzer/web/element_dsl'
require 'howitzer/web/iframe_dsl'

module Howitzer
  module Web
    # describe me!
    class BaseSection
      include ElementDsl
      include SectionDsl
      include IframeDsl

      attr_reader :parent, :capybara_context

      class << self
        attr_reader :default_finder_args
      end

      def initialize(parent, context)
        @parent = parent
        @capybara_context = context
      end
    end
  end
end
