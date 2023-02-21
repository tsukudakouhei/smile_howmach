class CreateMacMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :mac_menus do |t|
      t.string :name
      t.integer :price
      t.string :image

      t.timestamps
    end
  end
end
