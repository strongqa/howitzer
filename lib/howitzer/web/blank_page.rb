require 'howitzer/web/page'

# This class represents blank page
module Howitzer
  module Web
    class BlankPage < Page
      url 'about:blank'
      validate :url, /^about:blank$/
    end
  end  
end
