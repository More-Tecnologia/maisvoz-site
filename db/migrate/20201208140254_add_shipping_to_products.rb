class AddShippingToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :shipping, :boolean, default: false
  end
end
