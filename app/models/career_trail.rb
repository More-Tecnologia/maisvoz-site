class CareerTrail < ApplicationRecord

  belongs_to :career
  belongs_to :trail
  has_many :career_trail_users
  has_many :users, through: :career_trail_users
  has_one :product_score

  def calculate_bonus(score)
    score.to_f * maximum_bonus / 100.0
  end

  def calculate_maximum_bonus
    product_value = trail.product.price_cents / 100.0
    product_value * maximum_bonus / 100.0
  end

end
