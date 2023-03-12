class AddColumnSmilePrices < ActiveRecord::Migration[6.1]
  def change
    add_column :smile_prices, :body, :text
  end
end
