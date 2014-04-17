require 'howitzer/web_page'

class BlankPage < WebPage
  validates :url, pattern: /about:blank/
end