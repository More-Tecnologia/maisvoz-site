class CareerTrail < ApplicationRecord
  belongs_to :career
  belongs_to :trail
  has_many :career_trail_users
  has_many :users, through: :career_trail_users
end
