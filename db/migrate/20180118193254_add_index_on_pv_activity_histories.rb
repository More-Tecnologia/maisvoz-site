class AddIndexOnPvActivityHistories < ActiveRecord::Migration[5.1]
  def change
    add_index :pv_activity_histories, [:user_id, :order_id], unique: true
  end
end
