class ProductScore < ApplicationRecord
  belongs_to :career_trail
  belongs_to :product

  validates :generation, presence: true,
                         numericality: { only_integer: true }
  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }
end
