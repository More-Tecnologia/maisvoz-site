class BonusContract < ApplicationRecord

  belongs_to :order
  belongs_to :user

  validates :cent_amount, presence: true,
                          numericality: true
  validates :remaining_balance, presence: true,
                                numericality: true
  validates :received_balance, presence: true,
                               numericality: true

  has_many :financial_reasons

  def active?
    return false if expire_at.nil?
    return true if paid_at
    expire_at <= Date.current
  end

  def cent_amount
    self[:cent_amount] / 1e8.to_f if self[:cent_amount]
  end

  def cent_amount=(amount)
    self[:cent_amount] = (amount * 1e8).to_i
  end

  def remaining_balance
    self[:remaining_balance] / 1e8.to_f if self[:remaining_balance]
  end

  def remaining_balance=(amount)
    self[:remaining_balance] = (amount * 1e8).to_i
  end

  def received_balance
    self[:received_balance] / 1e8.to_f if self[:received_balance]
  end

  def received_balance=(amount)
    self[:received_balance] = (amount * 1e8).to_i
  end

end
