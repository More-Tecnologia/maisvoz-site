class CreateInvestmentShares < ActiveRecord::Migration[5.1]
  def change
    create_table :investment_shares do |t|
      t.references :investment, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :quantity, null: false
      t.string :name
      t.string :status
      t.bigint :gross_amount_cents
      t.bigint :net_amount_cents
      t.integer :bonus_cycle, null: false, default: 0

      t.timestamps
    end
  end
end
