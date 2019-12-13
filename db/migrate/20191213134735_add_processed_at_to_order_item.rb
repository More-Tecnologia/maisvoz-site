class AddProcessedAtToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :processed_at, :datetime
  end
end
