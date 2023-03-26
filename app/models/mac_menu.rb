class MacMenu < ApplicationRecord
  has_many :smileprices_macdmenus
  has_many :smile_prices, through: :smileprices_macdmenus

  scope :smileprice_and_below_menu, -> (smile_price) { where("price <= ? ", smile_price) }
  scope :random_choice, -> { order("RANDOM()") }
end
