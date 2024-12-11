FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 3, min_alpha: 3) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true) }
  end
end
