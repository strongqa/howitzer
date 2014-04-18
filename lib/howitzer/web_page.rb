require "rspec/expectations"
require "howitzer/utils/locator_store"
require "howitzer/utils/page_validator"
require "howitzer/capybara/dsl_ex"
require "singleton"

class WebPage

  BLANK_PAGE = 'about:blank' # @deprecated , use BlankPage instead
  IncorrectPageError = Class.new(StandardError)
  AmbiguousPageMatchingError = Class.new(StandardError)
  UnknownPage = Class.new

  include LocatorStore
  include Howitzer::Utils::PageValidator
  include RSpec::Matchers
  include Howitzer::Capybara::DslEx
  extend  Howitzer::Capybara::DslEx
  include Singleton

  def self.inherited(subclass)
    subclass.class_eval { include Singleton }
    Howitzer::Utils::PageValidator.pages << subclass
  end

  ##
  #
  # Opens web-site by given url
  #
  # *Parameters:*
  # * +url+ - Url string that will be opened
  #
  # *Returns:*
  # * +WebPage+ - New instance of current class
  #

  def self.open(url="#{app_url}#{self::URL}")
    log.info "Open #{self.name} page by '#{url}' url"
    retryable(tries: 2, logger: log, trace: true, on: Exception) do |retries|
      log.info "Retry..." unless retries.zero?
      visit url
    end
    given
  end

  ##
  #
  # Returns singleton instance of current web page
  #
  # *Returns:*
  # * +WebPage+ - Singleton instance
  #

  def self.given
    wait_for_opened
    self.instance
  end

  ##
  #
  # Returns current url
  #
  # *Returns:*
  # * +string+ - Current url
  #

  def self.url
    self.current_url
  end

  ##
  #
  # Returns body text of html page
  #
  # *Returns:*
  # * +string+ - Body text
  #

  def self.text
    page.find('body').text
  end

  ##
  #
  # Tries to identify current page name or raise error if ambiguous page matching
  #
  # *Returns:*
  # * +string+ - page name
  #

  def self.current_page
    page_list = matched_pages
    if page_list.count.zero?
      UnknownPage
    elsif page_list.count > 1
      log.error AmbiguousPageMatchingError,
                "Current page matches more that one page class (#{page_list.join(', ')}).\n\tCurrent url: #{current_url}\n\tCurrent title: #{title}"
    elsif page_list.count == 1
      page_list.first
    end
  end

  ##
  #
  # Waits until web page is not opened, or raise error after timeout
  #
  # *Parameters:*
  # * +time_out+ - Seconds that will be waiting for web page to be loaded
  #

  def self.wait_for_opened(timeout=settings.timeout_small)
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      self.opened? ? return : sleep(0.5)
    end
    log.error IncorrectPageError, "Current page: #{self.current_page}, expected: #{self}.\n\tCurrent url: #{current_url}\n\tCurrent title: #{title}"
  end

  def initialize
    check_validations_are_defined!
  end

  ##
  #
  # Fills in field that using Tinymce API
  #
  # *Parameters:*
  # * +name+ - Frame name that contains Tinymce field
  # * +Hash+ - Not required options
  #

  def tinymce_fill_in(name, options = {})
    if %w[selenium selenium_dev sauce].include? settings.driver
      page.driver.browser.switch_to.frame("#{name}_ifr")
      page.find(:css, '#tinymce').native.send_keys(options[:with])
      page.driver.browser.switch_to.default_content
    else
      page.execute_script("tinyMCE.get('#{name}').setContent('#{options[:with]}')")
    end
  end

  ##
  #
  # Accepts or declines JS alert box by given flag
  #
  # *Parameters:*
  # * +flag+ [TrueClass,FalseClass] - Determines accept or decline alert box
  #

   def click_alert_box(flag)
    if %w[selenium selenium_dev sauce].include? settings.driver
      if flag
        page.driver.browser.switch_to.alert.accept
      else
        page.driver.browser.switch_to.alert.dismiss
      end
    else
      if flag
        page.evaluate_script('window.confirm = function() { return true; }')
      else
        page.evaluate_script('window.confirm = function() { return false; }')
      end
    end
  end

  ##
  #
  # Clicks on button or link using JS event call
  #
  # *Parameters:*
  # * +css_locator+ - Css locator of link or button
  #

  def js_click(css_locator)
    page.execute_script("$('#{css_locator}').trigger('click')")
    sleep settings.timeout_tiny
  end

  # @deprecated
  # With Capybara 2.x it is extra
  #:nocov:
  def wait_for_ajax(timeout=settings.timeout_small, message=nil)
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      return true if page.evaluate_script('$.active') == 0
      sleep 0.25
    end
    log.error message || "Timed out waiting for ajax requests to complete"
  end
  #:nocov:

  ##
  # @deprecated
  #
  # Waits until web page is loaded
  #
  # *Parameters:*
  # * +expected_url+ - Url that will be waiting for
  # * +time_out+ - Seconds that will be waiting for web-site to be loaded until raise error
  #

  def wait_for_url(expected_url, timeout=settings.timeout_small)
    warn "[Deprecated] This method is deprecated, and will be removed in next version of Howitzer"
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      operator = expected_url.is_a?(Regexp) ? :=~ : :==
      return true if current_url.send(operator, expected_url).tap{|res| sleep 1 unless res}
    end
    log.error IncorrectPageError, "Current url: #{current_url}, expected:  #{expected_url}"
  end

  ##
  # @deprecated
  #
  # Waits until web is loaded with expected title
  #
  # *Parameters:*
  # * +expected_title+ - Page title that will be waited for
  # * +time_out+ - Seconds that will be waiting for web-site to be loaded until raise error
  #

  def wait_for_title(expected_title, timeout=settings.timeout_small)
    warn "[Deprecated] This method is deprecated, and will be removed in next version of Howitzer"
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      operator = expected_title.is_a?(Regexp) ? :=~ : :==
      return true if title.send(operator, expected_title).tap{|res| sleep 1 unless res}
    end
    log.error IncorrectPageError, "Current title: #{title}, expected:  #{expected_title}"
  end

  ##
  #
  # Reloads current page
  #

  def reload
    log.info "Reload '#{current_url}'"
    visit current_url
  end

  ##
  #
  # Returns Page title
  #
  # *Returns:*
  # * +string+ - Page title
  #

  def title
    page.title
  end

end
