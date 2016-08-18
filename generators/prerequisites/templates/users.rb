FactoryGirl.define do
  factory :user do
    email { "u#{serial}@#{Howitzer.mailgun_domain}" }
    name { "FirstName LastName #{serial}" }
    password { Howitzer.app_test_pass }
    password_confirmation { Howitzer.app_test_pass }

    trait :default do
      initialize_with { User.default || User.new }
    end
  end
end
