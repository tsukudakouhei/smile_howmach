FactoryBot.define do
  factory :user do
    name { "test_name" }
    email { 'test@example.com' }
    password { "password" }
    password_confirmation { "password" }

    trait :invalid do
      name { "" } # nameが空の場合
    end
  end
end
