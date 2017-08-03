class CreatePvHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :pv_histories do |t|
      t.references :order, foreign_key: true
      t.integer :direction, default: 0, null: false
      t.bigint :amount_cents, default: 0, null: false
      t.bigint :balance_cents, default: 0, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
