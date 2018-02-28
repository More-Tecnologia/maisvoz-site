class RemovePaymentStatusFromOrders < ActiveRecord::Migration[5.1]
  def up
    remove_column :orders, :payment_status
  end

  def down
    add_column :orders, :payment_status, :string
  end
end
