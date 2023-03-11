class CreateSmilepricesMacdmenus < ActiveRecord::Migration[6.1]
  def change
    create_table :smileprices_macdmenus do |t|
      t.references :smile_price, null: false, foreign_key: true
      t.references :mac_menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
