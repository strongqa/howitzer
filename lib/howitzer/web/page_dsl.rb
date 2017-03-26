module Howitzer
  module Web
    # This module combines page dsl methods
    module PageDsl
      # This class is for private usage only
      class PageScope
        include RSpec::Matchers
        include RSpec::Wait

        def initialize(page_klass, &block)
          self.page_klass = page_klass
          self.outer_context = eval('self', block.binding) if block.present?
          instance_eval(&block)
        end

        # Makes current page as a subject for Rspec expectations
        # @example
        #  HomePage.on { expect(HomePage.given).to have_menu_section } # Bad
        #  HomePage.on { is_expected.to have_menu_section } # Good

        def is_expected # rubocop:disable Style/PredicateName
          expect(page_klass.given)
        end

        # Proxies all methods to a page instance.
        #
        # @note There are some exceptions:
        #   * Methods with `be_` and `have_` prefixes are excluded
        #   * `out` method extracts an instance variable from an original context if starts from @.
        #    Otherwise it executes a method from an original context

        def method_missing(name, *args, &block)
          return super if name.match?(/\A(?:be|have)_/)
          return eval_in_out_context(*args, &block) if name == :out
          page_klass.given.send(name, *args, &block)
        end

        # Makes proxied methods to be evaludated and returned as a proc
        # @see #method_missing

        def respond_to_missing?(name, include_private = false)
          name !~ /\A(?:be|have)_/ || super
        end

        private

        def eval_in_out_context(*args, &block)
          return nil if args.size.zero?
          name = args.shift
          return get_outer_instance_variable(name) if name.to_s.start_with?('@')
          outer_context.send(name, *args, &block)
        end

        def get_outer_instance_variable(name)
          outer_context.instance_variable_get(name)
        end

        attr_accessor :page_klass, :outer_context
      end

      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end
      # This module holds page dsl class methods
      module ClassMethods
        # Allows to execute page methods in context of the page.
        # @note It additionally checks the page is really displayed
        #   on each method call, otherwise it raises error
        # @example Standard case
        #   LoginPage.open
        #   LoginPage.on do
        #     fill_form(name: 'John', email: 'jkarpensky@gmail.com')
        #     submit_form
        #   end
        # @example More complex case with outer context
        #   @name = 'John'
        #   def email(domain = 'gmail.com')
        #     "jkarpensky@#{domain}"
        #   end
        #   LoginPage.open
        #   LoginPage.on do
        #     fill_form(name: out(:@name), email: out(:email, 'yahoo.com'))
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
