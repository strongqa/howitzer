require 'howitzer/exceptions'

module Howitzer
  module Web
    # This module combines page validation methods
    module PageValidator
      @validations = {}

      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end

      # @return [Hash] defined validations for all page classes

      def self.validations
        @validations ||= {}
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
        # @param type [Symbol, String] a validation type. Possible values [:url, :element_presence, :title]
        # @param pattern_or_element_name [Symbol, String, Regexp]
        #   For :url and :title validation types must be <b>Regexp</b>
        #   For :element_presence must be one of element names described for the page
        # @param args [Array] any arguments required to pass for a lambda selector (:element_presence type only)
        # @param options [Hash] keyword arguments required to pass for a lambda selector (:element_presence type only)
        # @raise  [Howitzer::UnknownValidationError] if unknown validation type
        # @raise  [Howitzer::UndefinedElementError] if :element_presence validations refers to undefined element name
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
        #     validate :element_presence, :menu_item, lambda_args(text: 'Logout')
        #     element :menu_item, :xpath, ->(text:) { ".//a[.='#{text}']" }
        #   end

        def validate(type, pattern_or_element_name, *args, **options)
          case type.to_s.to_sym
          when :url, :title
            if args.present? || options.present?
              raise ArgumentError, "Additional arguments and options are not supported by '#{type}' the validator"
            end

            send("validate_by_#{type}", pattern_or_element_name)
          when :element_presence
            validate_by_element_presence(pattern_or_element_name, *args, **options)
          else
            raise Howitzer::UnknownValidationError, "unknown '#{type}' validation type"
          end
        end

        # Check whether current page is opened or no
        # @param sync [Boolean] if true then waits until validation true during Howitzer.capybara_wait_time
        #   or returns false. If false, returns result immediately
        # @return [Boolean]
        # @raise  [Howitzer::NoValidationError] if no one validation is defined for the page

        def opened?(sync: true)
          return validations.all? { |(_, validation)| validation.call(self, sync) } if validations.present?

          raise Howitzer::NoValidationError, "No any page validation was found for '#{name}' page"
        end

        # Finds all matched pages which satisfy of defined validations on current page
        # @return [Array] page name list

        def matched_pages
          PageValidator.validations.keys.select { |klass| klass.opened?(sync: false) }
        end

        # @return [Hash] defined validations for current page class

        def validations
          PageValidator.validations[self] ||= {}
        end

        private

        def validate_by_element_presence(element_name, *args, **options)
          validations[:element_presence] =
            lambda do |web_page, sync|
              if element_name.present? && !private_method_defined?("#{element_name}_element")
                raise(Howitzer::UndefinedElementError, ':element_presence validation refers to ' \
                                                       "undefined '#{element_name}' element on '#{name}' page.")
              end
              if sync
                web_page.instance.public_send("has_#{element_name}_element?", *args, **options)
              else
                !web_page.instance.public_send("has_no_#{element_name}_element?", *args, **options)
              end
            end
        end

        def validate_by_url(pattern)
          validations[:url] =
            ->(web_page, _sync) { pattern === web_page.instance.current_url }
        end

        def validate_by_title(pattern)
          validations[:title] =
            ->(web_page, sync) { sync ? web_page.instance.has_title?(pattern) : pattern === web_page.instance.title }
        end
      end
    end
  end
end
