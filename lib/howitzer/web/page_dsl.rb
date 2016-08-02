module Howitzer
  module Web
    # This module combines page dsl methods
    module PageDsl
      # This class is for private usage only
      class PageScope
        include RSpec::Matchers

        def initialize(page_klass, &block)
          self.page_klass = page_klass
          instance_eval(&block)
        end

        # rubocop:disable Style/PredicateName
        def is_expected
          expect(page_klass.given)
        end
        # rubocop:enable Style/PredicateName

        def method_missing(name, *args, &block)
          return super if name =~ /\A(?:be|have)_/
          page_klass.given.send(name, *args, &block)
        end

        def respond_to_missing?(name, include_private = false)
          !(name =~ /\A(?:be|have)_/) || super
        end

        private

        attr_accessor :page_klass
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
      # This module holds page dsl class methods
      module ClassMethods
        def on(&block)
          PageScope.new(self, &block)
          nil
        end
      end
    end
  end
end
