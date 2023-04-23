class AddSmileAnalysisScoreToSmilePrices < ActiveRecord::Migration[6.1]
  def change
    add_reference :smile_prices, :smile_analysis_score, null: false, foreign_key: true
  end
end
