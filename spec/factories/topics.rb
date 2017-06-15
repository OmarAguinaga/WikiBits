FactoryGirl.define do
  factory :topic do
    name Faker::Lorem.sentence
    description Faker::Lorem.paragraph
  end
end
