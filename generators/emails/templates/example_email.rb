class TestEmail < Email
  SUBJECT = "Test email"

  include Capybara::DSL

  def addressed_to?(new_user)
    /Hi #{new_user}/ === plain_text_body
  end
end