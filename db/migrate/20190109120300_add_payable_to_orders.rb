class AddPayableToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :payable, polymorphic: true
  end
end
