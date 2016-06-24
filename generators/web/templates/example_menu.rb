# This module is example of block element
module ExampleMenu
  def self.included(base)
    base.class_eval do
      element :menu_button, '.menuButton'
      element :account, :xpath, ".//*[@id='metaMenu']//a[contains(., 'Account')]"
      element :log_out, :xpath, ".//*[@id='metaMenu']//a[contains(., 'Log Out')]"
    end
  end

  def open_menu
    log.info 'Open menu'
    menu_button_element.click
  end
end
