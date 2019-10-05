class ProductScore < ApplicationRecord
  belongs_to :career_trail

  validates :generation, presence: true,
                         numericality: { only_integer: true }
  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }
end
