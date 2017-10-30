class CreateBonus < ActiveRecord::Migration[5.1]
  def change
    create_table :bonus do |t|
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true
      t.string :kind, null: false, index: true
      t.bigint :amount_cents, null: false

      t.timestamps
    end
  end
end
