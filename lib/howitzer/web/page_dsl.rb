module Howitzer
  module Web
    # This module combines page dsl methods
    module PageDsl
      # This class is for private usage only
      class PageScope
        def initialize(page_klass, &block)
          self.page_klass = page_klass
          instance_eval(&block) if block_given?
        end

        # rubocop:disable Style/PredicateName
        def is_expected
          expect(page_klass.given)
        end
        # rubocop:enable Style/PredicateName

        def method_missing(name, *args, &block)
          return super if name =~ /^be_/ || name =~ /^have_/
          page_klass.given.send(name, *args, &block)
        end

        private

        attr_accessor :page_klass
      end

      def self.included(base)
        class << base
          prepend ClassMethods
        end
      end
      # This module holds page dsl class methods
      module ClassMethods
        def on
          PageScope.new(self, &block)
          nil
        end
      end
    end
  end
end
