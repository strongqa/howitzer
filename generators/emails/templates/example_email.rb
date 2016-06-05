# This class is example of test email
class TestEmail < Howtzer::Email
  SUBJECT = 'Test email'.freeze

  def addressed_to?(new_user)
    /Hi #{new_user}/ === plain_text_body
  end
end
