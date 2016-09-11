require 'howitzer/exceptions'

module Howitzer
  module Web
    # This module combines page validation methods
    module PageValidator
      @validations = {}

      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      # @return [Hash] defined validations for all page classes

      def self.validations
        @validations ||= {}
      end

      # Returns page list
      # @return [Array]

      def self.pages
        @pages ||= []
      end

      # Checks if any validations are defined for the page
      # @raise  [Howitzer::NoValidationError] if no one validation is defined for the page

      def check_validations_are_defined!
        return if self.class.validations.present?

        raise Howitzer::NoValidationError, "No any page validation was found for '#{self.class.name}' page"
      end

      # This module holds page validation class methods
      module ClassMethods
        # Adds validation to validation list for current page
        # @param name [Symbol, String] a validation type. Possible values [:url, :element_presence, :title]
        # @param value [Symbol, String, Regexp]
        #   For :url and :title validation types must be <b>Regexp</b>
        #   For :element_presence must be one of element names described for page
        # @param additional_value [Object, nil] any value required to pass for a labmda selector
        # @raise  [Howitzer::UnknownValidationError] if unknown validation type
        # @example
        #   class ArticleListPage < Howitzer::Web::Page
        #     validate :title, /\ADemo web application - Listing Articles\z/
        #   end
        # @example
        #   class ArticlePage < Howitzer::Web::Page
        #     validate :url, %r{\/articles\/\d+\/?\z}
        #   end
        # @example
        #   class HomePage < Howitzer::Web::Page
        #     validate :element_presence, :menu_item, 'Logout'
        #     element :menu_item, :xpath, ->(name) { ".//a[.='#{name}']" }
        #   end

        def validate(name, value, additional_value = nil)
          validate_by_type(name, value, additional_value)
        end

        # Check whether current page is opened or no
        # @return [Boolean]
        # @raise  [Howitzer::NoValidationError] if no one validation is defined for the page

        def opened?
          if validations.present?
            return !validations.any? { |(_, validation)| !validation.call(self) }
          end
          raise Howitzer::NoValidationError, "No any page validation was found for '#{name}' page"
        end

        # Finds all matched pages which satisfy of defined validations on current page
        # @return [Array] page name list

        def matched_pages
          PageValidator.pages.select(&:opened?)
        end

        # @return [Hash] defined validations for current page class

        def validations
          PageValidator.validations[name] ||= {}
        end

        private

        def validate_element(element_name, value = nil)
          validations[:element_presence] =
            ->(web_page) { web_page.public_send(*["has_#{element_name}_element?", value].compact) }
        end

        def validate_by_url(pattern)
          validations[:url] =
            -> (web_page) { pattern === web_page.instance.current_url }
        end

        def validate_by_title(pattern)
          validations[:title] =
            -> (web_page) { pattern === web_page.instance.title }
        end

        def validate_by_type(type, value, additional_value)
          case type.to_s.to_sym
            when :url
              validate_by_url(value)
            when :element_presence
              validate_element(value, additional_value)
            when :title
              validate_by_title(value)
            else
              raise Howitzer::UnknownValidationError, "unknown '#{type}' validation type"
          end
        end
      end
    end
  end
end
