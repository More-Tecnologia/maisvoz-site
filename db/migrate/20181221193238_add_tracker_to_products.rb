class AddTrackerToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :tracker, :boolean, default: false, null: false
  end
end
