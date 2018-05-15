class AddProductToProductSetups < ActiveRecord::Migration[5.1]
  def change
    add_reference :product_setups, :product, foreign_key: true
  end
end
