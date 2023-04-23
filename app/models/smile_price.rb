class SmilePrice < ApplicationRecord
  belongs_to :user
  belongs_to :smile_analysis_score
  has_many :smileprices_macdmenus
  has_many :mac_menus, through: :smileprices_macdmenus
end
