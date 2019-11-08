class CreateVouchers < ActiveRecord::Migration[5.2]
  def change
    create_table :vouchers do |t|
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true
      t.string :code, null: false
      t.string :invoice_type
      t.datetime :used_at
      t.boolean :used, default: false, null: false

      t.timestamps
    end

    add_index :vouchers, :code, unique: true
  end
end
