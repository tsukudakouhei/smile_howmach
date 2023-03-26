class CreateSmilePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :smile_prices do |t|
      t.integer :price
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
