class AddWithdrawalToFinancialTransaction < ActiveRecord::Migration[5.2]
  def change
    add_reference :financial_transactions, :withdrawal, foreign_key: true
  end
end
