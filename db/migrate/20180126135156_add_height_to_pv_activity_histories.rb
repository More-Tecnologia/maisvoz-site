class AddHeightToPvActivityHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :pv_activity_histories, :height, :bigint
  end
end
