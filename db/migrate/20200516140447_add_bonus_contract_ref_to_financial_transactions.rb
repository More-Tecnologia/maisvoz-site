class AddBonusContractRefToFinancialTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :financial_transactions, :bonus_contract, foreign_key: true
  end
end
