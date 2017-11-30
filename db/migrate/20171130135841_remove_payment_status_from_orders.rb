class RemovePaymentStatusFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :payment_status
  end
end
