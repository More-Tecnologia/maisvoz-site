class Trail < ApplicationRecord

  belongs_to :product_bonus, class_name: 'Product',
                             optional: true

  has_many :career_trails
  has_many :careers, through: :career_trails
  has_many :users
  has_one :product

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :product, presence: true

  def greater_or_equal_to?(trail)
    product.price_cents >= trail.product.price_cents
  end

  def calculate_binary_bonus(score)
    score.to_f * product.binary_bonus_percent
  end

end
