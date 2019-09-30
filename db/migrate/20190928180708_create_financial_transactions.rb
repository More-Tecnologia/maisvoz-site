class CreateFinancialTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_transactions do |t|
      t.references :user, foreign_key: true
      t.references :financial_reason, foreign_key: true
      t.integer :operator_id, foreign_key: true, index: true
      t.integer :moneyflow, default: 0
      t.integer :cent_amount, default: 0

      t.timestamps
    end
  end
end
