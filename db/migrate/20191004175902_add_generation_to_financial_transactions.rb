class AddGenerationToFinancialTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_transactions, :generation, :integer
  end
end
