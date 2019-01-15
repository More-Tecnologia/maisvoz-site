class CreateInvestments < ActiveRecord::Migration[5.1]
  def change
    create_table :investments do |t|
      t.string :name
      t.bigint :total_cents, null: false
      t.bigint :price_cents, null: false
      t.integer :shares_available, default: 0
      t.integer :shares_total, default: 0
      t.integer :investment_cycles, default: 0
      t.decimal :investment_yield, precision: 5, scale: 2
      t.text :details
      t.string :status
      t.string :address
      t.string :phone
      t.string :whatsapp
      t.string :type

      t.timestamps
    end
    add_index :investments, :status
  end
end
