class Type < ApplicationRecord
  has_many :users

  validates :name, presence: true,
                   uniqueness: true
  validates :indications_quantity, numericality: { only_integer: true,
                                                   greater_than_or_equal_to: 0 }
  validates :bonus_percentage, numericality: { greater_than_or_equal_to: 0 }
end
