class Trail < ApplicationRecord
  has_many :career_trails
  has_many :careers, through: :career_trails
  has_one :product

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :product, presence: true
end
