class AddPaidAtToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :paid_at, :datetime
  end
end
