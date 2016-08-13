# This class is example of section
class MenuSection < Howitzer::Web::Section
  me :id, 'metaMenu'

  element :menu_button, '.menuButton'
  element :account, :xpath, ".//*[@id='metaMenu']//a[contains(., 'Account')]"
  element :log_out, :xpath, ".//*[@id='metaMenu']//a[contains(., 'Log Out')]"

  def logout
    Howitzer::Log.info 'Log out'
    log_out_element.click
  end
end
