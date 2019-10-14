class AddChargeBackToFinancialTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_transactions, :financial_transaction_id, :integer, foreign_key: true, index: true
  end
end
