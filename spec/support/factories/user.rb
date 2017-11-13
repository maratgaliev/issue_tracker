FactoryBot.define do
  factory :user do
    sequence(:login) {|n| "login#{n}"}
    sequence(:email) {|n| "email#{n}@example.com"}
    password 'password'
    role 'user'

    trait :moderator do
      role 'moderator'
    end
  end
end
