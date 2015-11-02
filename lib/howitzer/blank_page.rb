require 'howitzer/web_page'

# Description of blank page
class BlankPage < WebPage
  URL = 'about:blank'
  validate :url, pattern: /^about:blank$/
end
