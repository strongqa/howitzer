DriverNotSpecified = Class.new(StandardError)
SlBrowserNameNotSpecified = Class.new(StandardError)
TbBrowserNameNotSpecified = Class.new(StandardError)
SelBrowserNotSpecified = Class.new(StandardError)
CHECK_YOUR_SETTINGS_MSG = "Please check your settings"
DRIVER_NOT_SPECIFIED = DriverNotSpecified.new(CHECK_YOUR_SETTINGS_MSG)
SL_BROWSER_NAME_NOT_SPECIFIED = SlBrowserNameNotSpecified.new(CHECK_YOUR_SETTINGS_MSG)
TB_BROWSER_NAME_NOT_SPECIFIED = TbBrowserNameNotSpecified.new(CHECK_YOUR_SETTINGS_MSG)
SEL_BROWSER_NOT_SPECIFIED = SelBrowserNotSpecified.new(CHECK_YOUR_SETTINGS_MSG)

def sauce_driver?
  raise DRIVER_NOT_SPECIFIED if settings.driver.nil?
  settings.driver.to_sym == :sauce
end

def testingbot_driver?
  raise DRIVER_NOT_SPECIFIED if settings.driver.nil?
  settings.driver.to_sym == :testingbot
end

def selenium_driver?
  raise DRIVER_NOT_SPECIFIED if settings.driver.nil?
  settings.driver.to_sym == :selenium
end

def ie_browser?
  ie_browsers = [:ie, :iexplore]
  if sauce_driver?
    raise SL_BROWSER_NAME_NOT_SPECIFIED if settings.sl_browser_name.nil?
    ie_browsers.include?(settings.sl_browser_name.to_sym)
  elsif testingbot_driver?
    raise TB_BROWSER_NAME_NOT_SPECIFIED if settings.tb_browser_name.nil?
    ie_browsers.include?(settings.tb_browser_name.to_sym)
  elsif selenium_driver?
    raise SEL_BROWSER_NOT_SPECIFIED if settings.sel_browser.nil?
    ie_browsers.include?(settings.sel_browser.to_sym)
  end
end

def ff_browser?
  ff_browsers = [:ff, :firefox]
  if sauce_driver?
    raise SL_BROWSER_NAME_NOT_SPECIFIED if settings.sl_browser_name.nil?
    ff_browsers.include?(settings.sl_browser_name.to_sym)
  elsif testingbot_driver?
    raise TB_BROWSER_NAME_NOT_SPECIFIED if settings.tb_browser_name.nil?
    ff_browsers.include?(settings.tb_browser_name.to_sym)
  elsif selenium_driver?
    raise SEL_BROWSER_NOT_SPECIFIED if settings.sel_browser.nil?
    ff_browsers.include?(settings.sel_browser.to_sym)
  end
end


def chrome_browser?
  chrome_browser = :chrome
  if sauce_driver?
    raise SL_BROWSER_NAME_NOT_SPECIFIED if settings.sl_browser_name.nil?
    settings.sl_browser_name.to_sym == chrome_browser
  elsif testingbot_driver?
    raise TB_BROWSER_NAME_NOT_SPECIFIED if settings.tb_browser_name.nil?
    settings.tb_browser_name.to_sym == chrome_browser
  elsif selenium_driver?
    raise SEL_BROWSER_NOT_SPECIFIED if settings.sel_browser.nil?
    settings.sel_browser.to_sym == chrome_browser
  end
end


def app_url
  prefix = settings.app_base_auth_login.blank? ? '' : "#{settings.app_base_auth_login}:#{settings.app_base_auth_pass}@"
  app_base_url prefix
end


def app_base_url(prefix=nil)
  "#{settings.app_protocol || 'http'}://#{prefix}#{settings.app_host}"
end


def duration(time_in_numeric)
  secs = time_in_numeric.to_i
  mins = secs / 60
  hours = mins / 60
  if hours > 0
    "[#{hours}h #{mins % 60}m #{secs % 60}s]"
  elsif mins > 0
    "[#{mins}m #{secs % 60}s]"
  elsif secs >= 0
    "[0m #{secs}s]"
  end
end

def ri(value)
  raise value.inspect
end

class String

  def open(*args)
    as_page_class.open(*args)
  end

  def given
    as_page_class.new
  end

  def as_page_class
    Object.const_get("#{self.capitalize}Page")
  end
end
