class ChangeAmountInFinancialTransactions < ActiveRecord::Migration[5.2]
  def change
    change_column :financial_transactions, :cent_amount, :bigint
  end
end
