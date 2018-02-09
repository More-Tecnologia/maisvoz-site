class AddPvTotalToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :pv_total, :bigint, null: false, default: 0
  end
end
