class PoolLeadership < ApplicationRecord

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0,
                                     less_than_or_equal_to: 10_000 }

  def self.current_pool_leadership
    last
  end

  def self.current_pool_leadership_value
    current_pool_leadership.try(:amount).to_f
  end

end
