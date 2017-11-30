class CreateSystemFinancialLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :system_financial_logs do |t|
      t.string :description
      t.bigint :amount_cents
      t.string :kind
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
