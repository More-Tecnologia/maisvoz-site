class AddBalanceToPvActivityHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :pv_activity_histories, :balance, :bigint, null: false, default: 0
  end
end
