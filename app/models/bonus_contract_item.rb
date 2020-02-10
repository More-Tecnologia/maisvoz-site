class BonusContractItem < ApplicationRecord

  include Hashid::Rails

  belongs_to :financial_transaction
  belongs_to :bonus_contract

  def cent_amount
    self[:cent_amount] / 1e2.to_f if self[:cent_amount]
  end

  def cent_amount=(amount)
    self[:cent_amount] = (amount * 1e2).to_i
  end

end
