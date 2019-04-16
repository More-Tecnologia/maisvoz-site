class RemoveNullObligationFromPvActivityHistories < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:pv_activity_histories, :order_id, true)
  end
end
