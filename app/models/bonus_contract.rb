class BonusContract < ApplicationRecord

  include Hashid::Rails

  belongs_to :order
  belongs_to :user

  has_many :bonus_contract_items

  validates :cent_amount, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :remaining_balance, presence: true,
                                numericality: { greater_than_or_equal_to: 0 }
  validates :received_balance, presence: true,
                               numericality: { greater_than_or_equal_to: 0 }
  scope :active, -> { where('expire_at > ? AND paid_at IS NULL', Date.current) }

  def active?
    return false if paid_at || expire_at < Date.current
    return true
  end

  def cent_amount
    self[:cent_amount] / 1e2.to_f if self[:cent_amount]
  end

  def cent_amount=(amount)
    self[:cent_amount] = (amount * 1e2).to_i
  end

  def remaining_balance
    self[:remaining_balance] / 1e2.to_f if self[:remaining_balance]
  end

  def remaining_balance=(amount)
    self[:remaining_balance] = (amount * 1e2).to_i
  end

  def received_balance
    self[:received_balance] / 1e2.to_f if self[:received_balance]
  end

  def received_balance=(amount)
    self[:received_balance] = (amount * 1e2).to_i
  end

end