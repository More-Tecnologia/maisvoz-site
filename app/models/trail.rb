class Trail < ApplicationRecord
  has_many :career_trails
  has_many :careers, through: :career_trails
  has_many :trail_products
  has_many :products, through: :trail_products

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
end
