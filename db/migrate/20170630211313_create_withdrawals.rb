class CreateWithdrawals < ActiveRecord::Migration[5.1]
  def change
    create_table :withdrawals do |t|
      t.bigint :amount_cents, null: false
      t.integer :status, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
