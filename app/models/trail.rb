class Trail < ApplicationRecord
  has_many :career_trails
  has_many :careers, through: :career_trails

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
end
