class CreateSmileAnalysisScores < ActiveRecord::Migration[6.1]
  def change
    create_table :smile_analysis_scores do |t|
      t.integer :smile_score
      t.integer :eye_expression_score
      t.integer :mouth_expression_score
      t.integer :nose_position_score
      t.integer :jawline_score
      t.integer :naturalness_and_balance_score
      
      t.timestamps
    end
  end
end
