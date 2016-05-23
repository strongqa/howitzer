require_relative 'example_menu'
# This class is example of web page
class ExamplePage < WebPage
  url '/'
  validate :url, pattern: %r{\A(?:.*?:\/\/)?[^\/]*\/?\z}

  element :search_input, :fillable_field, 'lst-ib'
  element :search_btn, :button, 'btnK'

  include ExampleMenu

  def fill_keyword(data)
    search_input_element.set(data)
  end
end
