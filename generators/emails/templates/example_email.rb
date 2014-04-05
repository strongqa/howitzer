class TestEmail < Email
  self::SUBJECT = "Test email"


  def addressed_to?(new_user)
    /Hi #{new_user}/ === plain_text_body
  end
end