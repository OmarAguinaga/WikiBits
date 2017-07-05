require 'random_data'
FactoryGirl.define do
  factory :wiki do
    title Faker::Lorem.sentence
    body  RandomData.random_md
    private false
    topic
    user
  end
end
