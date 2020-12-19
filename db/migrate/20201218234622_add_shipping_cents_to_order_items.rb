class AddShippingCentsToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :shipping_cents, :integer, default: 0
  end
end
