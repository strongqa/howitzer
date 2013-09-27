module ExampleMenu

  def self.included(base)
    base.class_eval do
      add_locator         :menu_button,          ".menuButton"
      add_locator         :account,               xpath: ".//*[@id='metaMenu']//a[contains(., 'Account')]"
      add_locator         :log_out,               xpath: ".//*[@id='metaMenu']//a[contains(., 'Log Out')]"
    end
  end

  def open_menu
    log.info "Open menu"
    click_link locator(:menu_button)
  end
end