class AddPayerToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :payer, foreign_key: { to_table: :users }
  end
end
