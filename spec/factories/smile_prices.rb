FactoryBot.define do
  factory :smile_price do
    price { 1500 }
    body { 'test' }
    is_published { "true" }
    smile_analysis_score

    trait :invalid do
      name { "" } # nameが空の場合
    end
  end
end
