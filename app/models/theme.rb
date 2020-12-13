class Theme < ApplicationRecord
  validates :name, presence: true
  validates :font, presence: true
  validates :buttons_color, presence: true
end
