class PoolTranding < ApplicationRecord

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.46,
                                     less_than_or_equal_to: 0.5 }

  def self.current_pool_tranding
    last
  end

  def self.current_pool_tranding_value
    current_pool_tranding.try(:amount).to_f
  end

end
