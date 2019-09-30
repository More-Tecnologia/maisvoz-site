class ProductScore < ApplicationRecord
  belongs_to :career
  belongs_to :product
  belongs_to :trail

  validates :receiving_maximum_generation, presence: true,
                                           numericality: { only_integer: true }
  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }
end
