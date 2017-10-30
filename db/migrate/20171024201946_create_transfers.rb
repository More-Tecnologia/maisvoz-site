class CreateTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfers do |t|
      t.references :from_user, null: false, foreign_key: { to_table: :users }, index: true
      t.references :to_user, null: false, foreign_key: { to_table: :users }, index: true
      t.bigint :amount_cents, null: false

      t.timestamps
    end
  end
end
