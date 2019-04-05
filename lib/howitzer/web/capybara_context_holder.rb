module Howitzer
  module Web
    # This module mixin capybara context methods
    module CapybaraContextHolder
      # Returns capybara context. For example, capybara session, parent element, etc.

      def capybara_context
        capybara_scopes.last
      end

      private

      def capybara_scopes
        return super if defined?(super)

        raise NotImplementedError, "Please define 'capybara_scopes' method for class holder"
      end
    end
  end
end
