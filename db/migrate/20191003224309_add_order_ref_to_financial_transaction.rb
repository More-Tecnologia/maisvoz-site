class AddOrderRefToFinancialTransaction < ActiveRecord::Migration[5.2]
  def change
    add_reference :financial_transactions, :order, foreign_key: true
  end
end
