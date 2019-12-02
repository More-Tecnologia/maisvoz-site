class ProductScore < ApplicationRecord
  belongs_to :career_trail
  belongs_to :product_reason_score

  validates :generation, presence: true,
                         numericality: { only_integer: true }
  validates :amount_cents, presence: true,
                           numericality: true

  monetize :amount_cents

  def calculate_product_score(product_price)
    fix_value ? (amount_cents / 100.0) : calculate_percent_from(product_price)
  end

  def calculate_percent_from(product_price)
  (product_price / 100.0) * (amount_cents / 100.0) / 100.0
  end
end
