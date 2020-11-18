class AddSourceFinancialTransactionRefToFinancialTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :financial_transactions, :source_financial_transaction, foreign_key: { to_table: 'financial_transactions' }
  end
end
