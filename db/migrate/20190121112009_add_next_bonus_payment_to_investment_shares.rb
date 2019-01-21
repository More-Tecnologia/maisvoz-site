class AddNextBonusPaymentToInvestmentShares < ActiveRecord::Migration[5.1]
  def change
    add_column :investment_shares, :next_bonus_payment, :date
  end
end
