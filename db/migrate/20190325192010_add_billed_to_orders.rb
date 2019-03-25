class AddBilledToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :billed, :boolean, default: false
  end
end
