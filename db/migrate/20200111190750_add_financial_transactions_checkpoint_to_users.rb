class AddFinancialTransactionsCheckpointToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :financial_transactions_checkpoint, :text
  end
end
