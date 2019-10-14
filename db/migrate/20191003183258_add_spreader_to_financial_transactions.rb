class AddSpreaderToFinancialTransactions < ActiveRecord::Migration[5.2]
  def change
    rename_column :financial_transactions, :operator_id, :spreader_id
  end
end
