class AddNoteToFinancialTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_transactions, :note, :text, default: ''
  end
end
