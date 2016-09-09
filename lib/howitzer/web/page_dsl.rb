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

        # Makes current page as subject for Rspec expectations
        # @example
        #  HomePage.on { expect(HomePage.given).to have_menu_section } # Bad
        #  HomePage.on { is_expected.to have_menu_section } # Good

        def is_expected # rubocop:disable Style/PredicateName
          expect(page_klass.given)
        end

        # Proxies all methods to page instance except methods with be_ and have_ prefixes

        def method_missing(name, *args, &block)
          return super if name =~ /\A(?:be|have)_/
          page_klass.given.send(name, *args, &block)
        end

        # Makes proxied methods to be evaludated and returned as proc
        # @see #method_missing

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
        # Allows to execute page methods in context of the page.
        # @note It additionally checks the page is really displayed
        #   on each method call, otherwise it raises error
        # @example
        #   LoginPage.open
        #   LoginPage.on do
        #     fill_form(name: 'John', email: 'jkarpensky@gmail.com')
        #     submit_form
        #   end

        def on(&block)
          PageScope.new(self, &block)
          nil
        end
      end
    end
  end
end
