require 'howitzer/web_page'

class BlankPage < WebPage
  URL = 'about:blank'
  validate :url, pattern: /^about:blank$/
end
