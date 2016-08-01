module Howitzer
  module Web
    # This module combines iframe dsl methods
    module IframeDsl
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      def capybara_context
        super if defined?(super)
        raise NotImplementedError, "Please define 'capybara_context' method for class holder"
      end

      # This module holds frame dsl class methods
      module ClassMethods
        protected

        def iframe(name, selector)
          klass = "#{name}_page".classify.constantize
          define_iframe(klass, name, selector)
          define_has_iframe(name, selector)
          define_has_no_iframe(name, selector)
        end

        private

        def define_iframe(klass, name, selector)
          define_method "#{name}_iframe" do |&block|
            within_frame iframe_selector(selector) do
              block.call klass.instance
            end
          end
        end

        def define_has_iframe(name, selector)
          define_method("has_#{name}_iframe?") do
            capybara_context.has_selector?(iframe_element_selector(selector))
          end
        end

        def define_has_no_iframe(name, selector)
          define_method("has_no_#{name}_iframe?") do
            capybara_context.has_no_selector?(iframe_element_selector(selector))
          end
        end

        def iframe_selector(selector)
          selector.is_a?(Integer) ? selector : selector.split('#').last
        end

        def iframe_element_selector(selector)
          selector.is_a?(Integer) ? "iframe:nth-of-type(#{selector + 1})" : selector
        end
      end
    end
  end
end
