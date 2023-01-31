class CreateSmilePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :smile_prices do |t|
      t.integer :price
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
