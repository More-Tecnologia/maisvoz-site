class RemoveWidthFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :width, :decimal
  end
end
