module Howitzer
  module Utils
    module PageValidator
      WrongOptionError = Class.new(StandardError)
      NoValidationError = Class.new(StandardError)
      UnknownValidationName = Class.new(StandardError)
      @validations = {}

      def self.included(base)  #:nodoc:
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
      # @deprecated
      # This method will added for

      def check_validations_are_defined!
        if validations.nil? && !old_url_validation_present?
          raise NoValidationError, "No any page validation was found for '#{self.class.name}' page"
        end
      end

      private

      def validations
        PageValidator.validations[self.class.name]
      end

      def old_url_validation_present?
        if self.class.const_defined?("URL_PATTERN")
          self.class.validates :url, pattern: self.class.const_get("URL_PATTERN")
          warn "[Deprecated] Old style page validation is using. Please use new style:\n\t validates :url, pattern: URL_PATTERN"
          true
        end
      end

      module ClassMethods

        ##
        #
        # Adds validation to validation list
        #
        # @param [Symbol or String] name                                    Which validation type. Possible values [:url, :element_presence, :title]
        # @option options [Hash]                                            Validation options
        #    :pattern => [Regexp]                                             For :url and :title validation types
        #    :locator => [String]                                             For :element_presence (Existing locator name)
        # @raise  [Howitzer::Utils::PageValidator::UnknownValidationName]   If unknown validation type was passed
        #
        def validates(name, options)
          raise TypeError, "Expected options to be Hash, actual is '#{options.class}'" unless options.class == Hash
          PageValidator.validations[self.name] ||= {}
          case name.to_sym
            when :url
              validate_by_pattern(:url, options)
            when :element_presence
              validate_element options
            when :title
              validate_by_pattern(:title, options)
            else
              raise UnknownValidationName, "unknown '#{name}' validation name"
          end
        end

        ##
        # Check whether page is opened or no
        #
        # *Returns:*
        # * +boolean+
        #

        def opened?
          PageValidator.validations[self.name].all? {|(_, validation)| validation.call(self)}
        end

        private

        def validate_element(options)
          locator = options[:locator] || options["locator"]
          raise WrongOptionError, "Please specify ':locator' option as one of page locator names" if locator.nil? || locator.empty?
          PageValidator.validations[self.name][:element_presence] = lambda { |web_page| web_page.first_element(locator) }
        end

        def validate_by_pattern(name, options)
          pattern = options[:pattern] || options["pattern"]
          raise WrongOptionError, "Please specify ':pattern' option as Regexp object" if pattern.nil? || !pattern.is_a?(Regexp)
          PageValidator.validations[self.name][name] = lambda { |web_page| pattern === web_page.send(name) }
        end

      end
    end

  end
end