FactoryBot.define do
  factory :smile_analysis_score do
    smile_score { 50 }
    eye_expression_score { 10 }
    mouth_expression_score { 10 }
    nose_position_score { 10 }
    jawline_score { 10 }
    naturalness_and_balance_score { 10 }
  end
end