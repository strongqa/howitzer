require 'howitzer/web/page'

module Howitzer
  module Web
    # This class represents blank page
    class BlankPage < Page
      url 'about:blank'
      validate :url, /^about:blank$/
    end
  end
end
