class CreateFinancialEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :financial_entries do |t|
      t.string :description
      t.bigint :amount_cents, default: 0, null: false
      t.integer :kind, index: true, default: 0
      t.jsonb :metadata, null: false
      t.references :from, index: true, foreign_key: { to_table: :accounts }
      t.references :to, index: true, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
