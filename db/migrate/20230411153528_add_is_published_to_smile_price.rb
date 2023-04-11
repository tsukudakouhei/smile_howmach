class AddIsPublishedToSmilePrice < ActiveRecord::Migration[6.1]
  def change
    add_column :smile_prices, :is_published, :boolean, default: false, null: false

    SmilePrice.update_all(is_published: true)
  end
end
