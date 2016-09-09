module Howitzer
  module Web
    # This module combines iframe dsl methods
    module IframeDsl
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      # Returns capybara context. For example, capybara session, parent element, etc.
      # @abstract should be defined in parent context
      def capybara_context
        raise NotImplementedError, "Please define 'capybara_context' method for class holder"
      end

      private

      def iframe_element_selector(selector)
        selector.is_a?(Integer) ? ["iframe:nth-of-type(#{selector + 1})"] : [:frame, selector]
      end

      # This module holds frame dsl class methods
      module ClassMethods
        protected

        # Creates a group of methods to interact with described HTML frame on page
        # @note This method generates following dynamic methods:
        #
        #   <b><em>frame_name</em>_iframe</b> - equals capybara #within_frame(...) method
        #
        #   <b>has_<em>frame_name</em>_iframe?</b> - equals capybara #has_selector(...) method
        #
        #   <b>has_no_<em>frame_name</em>_iframe?</b> - equals capybara #has_no_selector(...) method
        # @param name [Symbol, String] unique iframe name
        # @param selector [Integer, String] frame name/id or index. Possible to specify id as #some_id
        # @example Using in page class
        #   class FbPage < Howitzer::Web::Page
        #     element :like, :xpath, ".//*[text()='Like']"
        #     def like
        #       like_element.click
        #     end
        #
        #     def liked?
        #       #some code here
        #     end
        #   end
        #
        #   class HomePage < Howitzer::Web::Page
        #     iframe :fb, 1
        #   end
        #
        #   HomePage.on do
        #     fb_iframe do |frame|
        #       frame.like
        #       expect(frame).to be_liked
        #     end
        #   end
        #   HomePage.on { is_expected.to have_fb_iframe }
        # @!visibility public

        def iframe(name, selector)
          klass = "#{name}_page".classify.constantize
          define_iframe(klass, name, selector)
          define_has_iframe(name, selector)
          define_has_no_iframe(name, selector)
        end

        private

        def define_iframe(klass, name, selector)
          define_method "#{name}_iframe" do |&block|
            iframe_selector = selector.is_a?(Integer) ? selector : selector.split('#').last
            capybara_context.within_frame(iframe_selector) do
              block.call klass.instance
            end
          end
        end

        def define_has_iframe(name, selector)
          define_method("has_#{name}_iframe?") do
            capybara_context.has_selector?(*iframe_element_selector(selector))
          end
        end

        def define_has_no_iframe(name, selector)
          define_method("has_no_#{name}_iframe?") do
            capybara_context.has_no_selector?(*iframe_element_selector(selector))
          end
        end
      end
    end
  end
end
