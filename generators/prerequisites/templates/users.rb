FactoryGirl.define do
  factory :user do
    email { "u#{serial}@#{settings.mailgun_domain}" }
    name { "FirstName LastName #{serial}" }
    password { settings.app_test_pass }
    password_confirmation { settings.app_test_pass }
  end
end
