require 'howitzer/web_page'

class BlankPage < WebPage
  URL = 'about:blank'
  validates :url, pattern: /about:blank/
end