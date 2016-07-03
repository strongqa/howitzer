require_relative 'element_dsl'

module Howitzer
  module Web
    # describe me!
    class BaseSection
      include ElementDsl

      attr_reader :parent, :context

      class << self
        attr_reader :default_finder_args
      end

      def initialize(parent, context)
        @parent = parent
        @context = context
      end
    end
  end
end
