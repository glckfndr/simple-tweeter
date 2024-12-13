FactoryBot.define do
  factory :tweet do
    content { Faker::Lorem.sentence(word_count: 50).truncate(255) }
    association :user
  end
end
