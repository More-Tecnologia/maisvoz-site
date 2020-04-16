class PoolTranding < ApplicationRecord

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: ENV['POOL_TRADING_MINIMUM'].to_f,
                                     less_than_or_equal_to: ENV['POOL_TRADING_MAXIMUM'].to_f }

  def self.current_pool_tranding
    last
  end

  def self.current_pool_tranding_value
    current_pool_tranding.try(:amount).to_f
  end

end
