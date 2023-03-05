class SmilePrice < ApplicationRecord
  belongs_to :user
  has_many :smileprices_macdmenus
  has_many :mac_menus, through: :smileprices_macdmenus
end
