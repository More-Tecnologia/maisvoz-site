class Type < ApplicationRecord
  has_many :users

  validates :name, presence: true,
                   uniqueness: true
  validates :indications_quantity, numericality: { only_integer: true,
                                                   greater_than_or_equal_to: 0 }
  validates :bonus_percentage, numericality: { greater_than_or_equal_to: 0 }
  validates :withdrawal_minimum, numericality: { greater_than_or_equal_to: 0,
                                                 less_than_or_equal_to: 100 },
                                 if: :withdrawal_in_percent
  validates :withdrawal_minimum, numericality: { greater_than_or_equal_to: 0 },
                                 unless: :withdrawal_in_percent

  def withdrawal_minimum_amount(value = 0)
    return value * withdrawal_minimum / 100.0 if withdrawal_in_percent

    withdrawal_minimum
  end
end
