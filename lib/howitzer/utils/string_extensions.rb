module Howitzer
  module Utils
    # This module extends standard String class with useful methods for Cucumber step definitions
    module StringExtensions
      def open(*args)
        as_page_class.open(*args)
      end

      # Returns an instantiated page by name
      # @example
      #   'home'.given #=> HomePage.given
      # @see Howitzer::Web::Page.given

      def given
        as_page_class.given
      end

      # Waits until a page is opened or raises error
      # @example
      #   'home'.displayed? #=> HomePage.displayed?
      # @see Howitzer::Web::Page.displayed?

      def displayed?
        as_page_class.displayed?
      end

      # Returns a page class by name
      # @example
      #   'home'.as_page_class #=> HomePage
      # @see Howitzer::Web::Page

      def as_page_class
        as_class('Page')
      end

      # Returns an email class by name
      # @example
      #   'Reset Password'.as_email_class #=> ResetPasswordEmail
      # @see Howitzer::Email

      def as_email_class
        as_class('Email')
      end

      # Executes code in context of the page
      # @example
      #   'home'.on { puts 1 } #=> HomePage.on { puts 1 }
      # @see Howitzer::Web::Page.on

      def on(&block)
        as_page_class.on(&block)
      end

      private

      def as_class(type)
        "#{gsub(/\s/, '_').camelize}#{type}".constantize
      end
    end
  end
end
