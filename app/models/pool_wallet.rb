# frozen_string_literal: true

class PoolWallet < ApplicationRecord
  validates :title, presence: true
  validates :cent_amount, presence: true
  validates :wallet, presence: true
end
