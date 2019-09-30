class TrailProduct < ApplicationRecord
  belongs_to :trail
  belongs_to :product

  validates :product, uniqueness: { scope: :trail_id }
end
