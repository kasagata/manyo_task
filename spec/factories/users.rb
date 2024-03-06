FactoryBot.define do
  factory :user do
    name { "testuser" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    admin { false }
  end
end
