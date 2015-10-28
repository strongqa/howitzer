FactoryGirl.define do
  factory :user do
    email { "u#{Gen.serial}@#{settings.mailgun_domain}" }
    name { "FirstName LastName #{Gen.serial}" }
    password { settings.def_test_pass }
    password_confirmation { settings.def_test_pass }
  end
end
