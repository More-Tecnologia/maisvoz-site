# frozen_string_literal: true

class Pool < ApplicationRecord
  validates :title, presence: true
  validates :cent_amount, presence: true
  validates :wallet_hash, presence: true
end
