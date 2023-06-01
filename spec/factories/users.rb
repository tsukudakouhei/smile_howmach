FactoryBot.define do
  factory :user do
    name { "test_name" }
    email { 'test@example.com' }
    password { "password" }
    password_confirmation { "password" }

    trait :invalid do
      name { "" } # nameが空の場合
    end

    trait :invalid_email do
      email { "invalid_email" } # emailが形式が正しくない場合
    end
  end
end
