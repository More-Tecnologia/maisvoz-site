class AddProfitAmountCentsToInvestmentShares < ActiveRecord::Migration[5.1]
  def change
    add_column :investment_shares, :profit_amount_cents, :bigint, default: 0, null: false
  end
end
