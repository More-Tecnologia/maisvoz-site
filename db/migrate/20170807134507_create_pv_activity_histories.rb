class CreatePvActivityHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :pv_activity_histories do |t|
      t.references :order, foreign_key: true, null: false
      t.bigint :amount_cents, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
