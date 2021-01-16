class RemoveLengthFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :length, :decimal
  end
end
