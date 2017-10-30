class CreateDebits < ActiveRecord::Migration[5.1]
  def change
    create_table :debits do |t|
      t.references :operated_by, foreign_key: { to_table: :users }
      t.references :user, foreign_key: true, index: true, null: false
      t.string :message
      t.bigint :amount_cents, null: false

      t.timestamps
    end
  end
end
