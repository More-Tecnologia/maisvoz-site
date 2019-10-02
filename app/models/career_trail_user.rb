class CareerTrailUser < ApplicationRecord
  belongs_to :career_trail
  belongs_to :user
end
