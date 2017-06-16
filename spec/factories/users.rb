FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    username {Faker::Internet.user_name}
    password {Faker::Internet.password}
    confirmed_at          Time.now
  end

  factory :confirmed_user, :parent => :user do
    after(:create) { |user| user.confirm }
  end

  factory :unconfirmed_user, :parent => :user do
    after(:create) { |user| user.skip_confirmation! }
  end
end
