require 'howitzer/exceptions'

module Howitzer
  module Utils
    module PageValidator
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
        if validations.nil? && !old_url_validation_present?
          log.error Howitzer::NoValidationError, "No any page validation was found for '#{self.class.name}' page"
        end
      end

      private

      def validations
        PageValidator.validations[self.class.name]
      end

      def old_url_validation_present?
        if self.class.const_defined?('URL_PATTERN')
          self.class.validates :url, pattern: self.class.const_get('URL_PATTERN')
          warn "[Deprecated] Old style page validation is using. Please use new style:\n" \
               "\t validates :url, pattern: URL_PATTERN"
          true
        end
      end

      module ClassMethods
        ##
        #
        # Adds validation to validation list
        #
        # @param [Symbol or String] name       Which validation type. Possible values [:url, :element_presence, :title]
        # @option options [Hash]                      Validation options
        #    :pattern => [Regexp]                     For :url and :title validation types
        #    :locator => [String]                     For :element_presence (Existing locator name)
        # @raise  [Howitzer::UnknownValidationError]  If unknown validation type was passed
        #
        def validates(name, options)
          log.error TypeError, "Expected options to be Hash, actual is '#{options.class}'" unless options.class == Hash
          PageValidator.validations[self.name] ||= {}
          case name.to_s.to_sym
            when :url
              validate_by_pattern(:url, options)
            when :element_presence
              validate_element options
            when :title
              validate_by_pattern(:title, options)
            else
              log.error Howitzer::UnknownValidationError, "unknown '#{name}' validation name"
          end
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
          validation_list = PageValidator.validations[name]
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
          PageValidator.pages.select(&:opened?)
        end

        private

        def validate_element(options)
          locator = options[:locator] || options['locator']
          if locator.nil? || locator.empty?
            log.error Howitzer::WrongOptionError, "Please specify ':locator' option as one of page locator names"
          end
          PageValidator.validations[name][:element_presence] = ->(web_page) { web_page.first_element(locator) }
        end

        def validate_by_pattern(name, options)
          pattern = options[:pattern] || options['pattern']
          if pattern.nil? || !pattern.is_a?(Regexp)
            log.error Howitzer::WrongOptionError, "Please specify ':pattern' option as Regexp object"
          end
          PageValidator.validations[self.name][name] = ->(web_page) { pattern === web_page.send(name) }
        end
      end
    end
  end
end
