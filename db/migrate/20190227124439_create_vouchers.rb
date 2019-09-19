class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers do |t|
      t.string :code, null: false
      t.boolean :used, default: false, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :vouchers, :code, unique: true
  end
end
