# This class is example of web page
class ExamplePage < Howitzer::Web::Page
  path '/'
  validate :url, %r{\A(?:.*?:\/\/)?[^\/]*\/?\z}

  section :menu

  element :search_input, :fillable_field, 'lst-ib'
  element :search_btn, :button, 'btnK'

  def fill_keyword(data)
    search_input_element.set(data)
  end
end
