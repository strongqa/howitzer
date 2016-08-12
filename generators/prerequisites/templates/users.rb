FactoryGirl.define do
  factory :user do
    email { "u#{Howitzer::Utils::Gen.serial}@#{settings.mailgun_domain}" }
    name { "FirstName LastName #{Howitzer::Utils::Gen.serial}" }
    password { settings.app_test_pass }
    password_confirmation { settings.app_test_pass }
  end
end
