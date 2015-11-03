require 'howitzer/web_page'

# This class represents blank page
class BlankPage < WebPage
  url 'about:blank'
  validate :url, pattern: /^about:blank$/
end
