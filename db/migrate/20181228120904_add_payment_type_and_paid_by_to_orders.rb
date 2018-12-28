class AddPaymentTypeAndPaidByToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_type, :string
    add_column :orders, :paid_by, :string
  end
end
