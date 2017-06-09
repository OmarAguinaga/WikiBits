FactoryGirl.define do
  factory :wiki do
    title Faker::Lorem.sentences
    body Faker::Lorem.paragraph
    private false
    user
  end
end
