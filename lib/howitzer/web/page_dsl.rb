module Howitzer
  module Web
    # This module combines page dsl methods
    module PageDsl
      # This class is for private usage only
      class PageScope
        include RSpec::Matchers

        def initialize(page_klass, &block)
          self.page_klass = page_klass
          instance_eval(&block) if block_given?
        end

        def expected?
          expect(page_klass.given)
        end

        def method_missing(name, *args, &block)
          return super if name =~ /^be_/ || name =~ /^have_/
          page_klass.given.send(name, *args, &block)
        end

        private

        attr_accessor :page_klass
      end
      # This class is for self usage
      class ParentPage
        def self.open(&block)
          PageScope.new(self, &block)
          given
        end

        def self.on(&block)
          PageScope.new(self, &block)
        end
      end
    end
  end
end
