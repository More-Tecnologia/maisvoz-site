# frozen_string_literal: true

class PoolWallet < ApplicationRecord
  validates :title, presence: true
  validates :cent_amount, presence: true
  validates :wallet, presence: true

  def add_amount(amount)
    increment(:cent_amount, amount.to_f * 1e8).save!
  end

  def cent_amount
    self[:cent_amount] / 1e8.to_f if self[:cent_amount]
  end
end
