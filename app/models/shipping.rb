class Shipping < ApplicationRecord
  belongs_to :product

  validates :amount, presence: true,
                     numericality: { greater_than: 0 }
  validates :country, presence: true,
                      uniqueness: { scoped_to: :product }
end
