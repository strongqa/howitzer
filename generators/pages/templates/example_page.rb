require_relative 'example_menu'
# This class is example of web page
class ExamplePage < WebPage
  URL = '/'
  validate :url, pattern: %r{\A(?:.*?:\/\/)?[^\/]*\/?\z}

  add_field_locator :search_input, 'lst-ib'
  add_button_locator :search_btn, 'btnK'

  include ExampleMenu

  def fill_keyword(data)
    fill_in field_locator(:search_input), data
  end
end
