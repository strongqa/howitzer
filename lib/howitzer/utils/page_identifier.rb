module Howitzer
  module Utils
    module PageIdentifier
      AmbiguousMatchingPageError = Class.new(StandardError)

      @validations = {}

      def self.validations
        @validations
      end

      def self.identify_page(url, title)
        raise ArgumentError, "Url and title can not be blank. Actual: url=#{url}, title=#{title}" if url.blank? || title.blank?
        @validations.inject([]) do |res, (page, validation_data)|
          is_found = case [!!validation_data[:url], !!validation_data[:title]]
                      when [true, true]
                        validation_data[:url] === url && validation_data[:title] === title
                      when [true, false]
                        validation_data[:url] === url
                      when [false, true]
                        validation_data[:title] === title
                      when [false, false]
                        raise Howitzer::Utils::PageValidator::NoValidationError, "No any page validation was found for '#{page}' page"
                      else nil
                     end
          res << page if is_found
          res
        end.sort
      end
    end
  end
end


