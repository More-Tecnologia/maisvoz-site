class RemoveProductModelFromProductSetups < ActiveRecord::Migration[5.1]
  def change
    remove_column :product_setups, :product_model
  end
end
