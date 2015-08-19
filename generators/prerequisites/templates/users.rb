FactoryGirl.define do
  factory :user do
    email { "u#{generate(:serial)}@#{settings.mailgun_domain}" }
    name { "FirstName LastName #{generate(:serial)}" }
    password { settings.def_test_pass }
    password_confirmation { settings.def_test_pass }
  end
end