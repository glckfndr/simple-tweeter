FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }
    username { "testuser" }
  end
end
