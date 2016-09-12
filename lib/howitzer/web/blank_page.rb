require 'howitzer/web/page'

module Howitzer
  module Web
    # This class represents standard blank page in browser
    class BlankPage < Page
      site ''
      path 'about:blank'
      validate :url, /^about:blank$/
    end
  end
end
