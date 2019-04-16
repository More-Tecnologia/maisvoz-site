class CreateOrderOfServices < ActiveRecord::Migration[5.2]
  def change
    create_table :order_of_services do |t|
      t.references :user, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.string :os_number
      t.bigint :gross_sales_cents, default: 0, null: false
      t.bigint :net_sales_cents, default: 0, null: false
      t.bigint :gross_service_cents, default: 0, null: false
      t.bigint :net_service_cents, default: 0, null: false
      t.bigint :profit_cents, default: 0, null: false
      t.integer :total_score, default: 0, null: false

      t.timestamps
    end
    add_index :order_of_services, :os_number, unique: true
  end
end
