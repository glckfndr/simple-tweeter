FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 3)  }
    email { Faker::Internet.email }
    password {'@Password123!'}
    password_confirmation { '@Password123!'}
    # password { Faker::Internet.password(min_length: 8, mix_case: true,
    # special_characters: true) }
    # password_confirmation { password }
  end
end
