require 'howitzer/web_page'

# This class describes blank page
class BlankPage < WebPage
  URL = 'about:blank'
  validate :url, pattern: /^about:blank$/
end
