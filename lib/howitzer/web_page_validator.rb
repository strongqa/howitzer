require 'howitzer/exceptions'

module Howitzer
  # This module combines page validation methods
  module WebPageValidator
    @validations = {}

    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end

    ##
    #
    # Returns validation list
    #
    # @return [Hash]
    #
    def self.validations
      @validations
    end

    ##
    #
    # Returns page list
    #
    # @return [Array]
    #
    def self.pages
      @pages ||= []
    end

    ##
    # Check if any validations are defined, if no, tries to find old style, else raise error
    #
    # @raise  [Howitzer::NoValidationError] If no one validation is defined for page
    #

    def check_validations_are_defined!
      return unless validations.nil?

      log.error Howitzer::NoValidationError, "No any page validation was found for '#{self.class.name}' page"
    end

    private

    def validations
      WebPageValidator.validations[self.class.name]
    end

    # This module holds page validation class methods
    module ClassMethods
      ##
      #
      # Adds validation to validation list
      #
      # @param [Symbol or String] name       Which validation type. Possible values [:url, :element_presence, :title]
      # @option options [Hash]                      Validation options
      #    :pattern => [Regexp]                     For :url and :title validation types
      #    :name => [String]                        For :element_presence (Existing element name)
      # @raise  [Howitzer::UnknownValidationError]  If unknown validation type was passed
      #
      def validate(name, value, additional_value = nil)
        WebPageValidator.validations[self.name] ||= {}
        validate_by_type(name, value, additional_value)
      end

      ##
      # Check whether page is opened or no
      #
      # @raise  [Howitzer::NoValidationError] If no one validation is defined for page
      #
      # *Returns:*
      # * +boolean+
      #

      def opened?
        validation_list = WebPageValidator.validations[name]
        if validation_list.blank?
          log.error Howitzer::NoValidationError, "No any page validation was found for '#{name}' page"
        else
          !validation_list.any? { |(_, validation)| !validation.call(self) }
        end
      end

      ##
      #
      # Finds all matched pages which are satisfy of defined validations
      #
      # *Returns:*
      # * +array+ - page names
      #

      def matched_pages
        WebPageValidator.pages.select(&:opened?)
      end

      private

      def validate_element(element_name, value = nil)
        WebPageValidator.validations[name][:element_presence] =
          ->(web_page) { web_page.public_send(*["has_#{element_name}_element?", value].compact) }
      end

      def validate_by_url(pattern)
        WebPageValidator.validations[name][:url] =
          -> (web_page) { pattern === web_page.current_url }
      end

      def validate_by_title(pattern)
        WebPageValidator.validations[name][:title] =
          -> (web_page) { pattern === web_page.title }
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
            log.error Howitzer::UnknownValidationError, "unknown '#{type}' validation type"
        end
      end
    end
  end
end
