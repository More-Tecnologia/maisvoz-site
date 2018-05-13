class AddImagesDataToProductSetups < ActiveRecord::Migration[5.1]
  def change
    add_column :product_setups, :checkin_data, :json
    add_column :product_setups, :checkout_data, :json
    add_column :product_setups, :scanner_in_data, :json
    add_column :product_setups, :scanner_out_data, :json
    add_column :product_setups, :installation_data, :json
  end
end
