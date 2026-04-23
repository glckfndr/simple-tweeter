FactoryBot.define do
  factory :comment do
    # Why: keep generated content short enough to satisfy validation in most tests.
    content { Faker::Lorem.sentence(word_count: 12).truncate(255) }
    association :tweet
    association :user
  end
end
