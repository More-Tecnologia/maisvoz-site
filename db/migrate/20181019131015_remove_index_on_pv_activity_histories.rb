class RemoveIndexOnPvActivityHistories < ActiveRecord::Migration[5.1]
  def up
    remove_index :pv_activity_histories, [:user_id, :order_id]
  end

  def down
    add_index :pv_activity_histories, [:user_id, :order_id], unique: true
  end
end
