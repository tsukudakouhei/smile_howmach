class ChangeDefaultOfIsPublishedInSmilePrices < ActiveRecord::Migration[6.1]
  def change
    change_column_default :smile_prices, :is_published, from: false, to: true
  end
end
