require 'singleton'
require 'capybara'
require 'rspec/expectations'
require 'addressable/template'
require 'howitzer/web/page_validator'
require 'howitzer/web/element_dsl'
require 'howitzer/web/iframe_dsl'
require 'howitzer/web/page_dsl'
require 'howitzer/web/section_dsl'
require 'howitzer/exceptions'

module Howitzer
  module Web
    # This class represents single web page. This is parent class for all web pages
    class Page
      UnknownPage = Class.new
      PROXY_CAPYBARA_METHODS = Capybara::Session::SESSION_METHODS +
                               Capybara::Session::MODAL_METHODS +
                               [:driver, :text]

      include Singleton
      include ElementDsl
      include IframeDsl
      include PageDsl
      include SectionDsl
      include PageValidator
      include ::RSpec::Matchers

      PROXY_CAPYBARA_METHODS.each do |method|
        define_method(method) { |*args, &block| Capybara.current_session.send(method, *args, &block) }
      end

      # This Ruby callback makes all inherited classes as singleton classes.
      # In additional it addes current page to page validator pages in case
      # if it has any defined validations.
      def self.inherited(subclass)
        subclass.class_eval { include Singleton }
        PageValidator.pages << subclass if subclass.validations.present?
      end

      # Opens a web page in browser
      # @note It tries to open page twice and then raises error if validation is failed
      # @param validate [Boolean] if fase will skip current page validation (is opened)
      # @param params [Array] - placeholder names and their values
      # @return [Page]

      def self.open(validate: true, **params)
        url = expanded_url(params)
        Howitzer::Log.info "Open #{name} page by '#{url}' url"
        retryable(tries: 2, logger: Howitzer::Log, trace: true, on: Exception) do |retries|
          Howitzer::Log.info 'Retry...' unless retries.zero?
          Capybara.current_session.visit(url)
        end
        given if validate
      end

      # Returns singleton instance of the web page
      # @return [Page]

      def self.given
        displayed?
        instance
      end

      # Tries to identify current page name or raise error if ambiguous page matching
      # @return [String] page name
      # @raise [UnknownPage] when no any matched pages
      # @raise [AmbiguousPageMatchingError] when matched more than 1 page

      def self.current_page
        page_list = matched_pages
        return UnknownPage if page_list.count.zero?
        return Howitzer::Log.error(AmbiguousPageMatchingError, ambiguous_page_msg(page_list)) if page_list.count > 1
        return page_list.first if page_list.count == 1
      end

      # Waits until web page is opened
      # @param time_out [Integer] time in seconds required web page to be loaded
      # @return [Boolean]
      # @raise [IncorrectPageError] when timeout expired and page is not displayed

      def self.displayed?(timeout = Howitzer.page_load_idle_timeout)
        end_time = ::Time.now + timeout
        until ::Time.now > end_time
          return true if opened?
          sleep(0.5)
        end
        Howitzer::Log.error IncorrectPageError, incorrect_page_msg
      end

      # @return [String] current page url from browser

      def self.current_url
        Capybara.current_session.current_url
      end

      # Returns expanded page url for page opening
      # @param params [Array] placeholders and their values
      # @return [String]

      def self.expanded_url(params = {})
        return "#{parent_url}#{Addressable::Template.new(url_template).expand(params)}" unless url_template.nil?
        raise PageUrlNotSpecifiedError, "Please specify url for '#{self}' page. Example: url '/home'"
      end

      class << self
        protected

        # DSL to specify url pattern for page opening
        # @param value [String] url pattern, for details please see Addressable gem
        # @see .parent_url
        # @example
        #   class ArticlePage < Howitzer::Web::Page
        #     url '/articles/:id'
        #   end
        #   ArticlePage.open(id: 10)
        # @!visibility public

        def url(value)
          @url_template = value.to_s
        end

        # DSL to specify root url for page opening
        # @note By default it specifies Howitzer.app_uri.site as root url
        # @param value [String] host
        # @example
        #   class AuthPage < Howitzer::Web::Page
        #     parent_url 'https:/example.com'
        #   end
        #
        #   class LoginPage < AuthPage
        #     url '/login'
        #   end
        # @!visibility public

        def root_url(value)
          define_singleton_method(:parent_url) { value }
          private_class_method :parent_url
        end

        private

        attr_reader :url_template

        def incorrect_page_msg
          "Current page: #{current_page}, expected: #{self}.\n" \
                    "\tCurrent url: #{current_url}\n\tCurrent title: #{instance.title}"
        end

        def ambiguous_page_msg(page_list)
          "Current page matches more that one page class (#{page_list.join(', ')}).\n" \
                    "\tCurrent url: #{current_url}\n\tCurrent title: #{instance.title}"
        end
      end

      root_url Howitzer.app_uri.site

      def initialize
        check_validations_are_defined!
        current_window.maximize if Howitzer.maximized_window
      end

      # Accepts or declines JS alert box by given flag
      # @param flag [Boolean] Determines accept or decline alert box

      def click_alert_box(flag)
        if %w(selenium sauce).include? Howitzer.driver
          alert = driver.browser.switch_to.alert
          flag ? alert.accept : alert.dismiss
        else
          evaluate_script("window.confirm = function() { return #{flag}; }")
        end
      end

      # Reloads current page in browser

      def reload
        Howitzer::Log.info "Reload '#{current_url}'"
        visit current_url
      end

      # Returns capybara context as current session

      def capybara_context
        Capybara.current_session
      end
    end
  end
end
