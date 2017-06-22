class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.integer :subtotal_cents, default: 0
      t.integer :tax_cents, default: 0
      t.integer :shipping_cents, default: 0
      t.integer :total_cents, default: 0
      t.integer :status, default: 0
      t.integer :payment_status, default: 0

      t.timestamps
    end
  end
end
