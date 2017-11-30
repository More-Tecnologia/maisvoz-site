class CreateFinancialEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :financial_entries do |t|
      t.string :description
      t.bigint :amount_cents, default: 0, null: false
      t.bigint :balance_cents, default: 0, null: false
      t.string :kind, index: true, default: 0
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
