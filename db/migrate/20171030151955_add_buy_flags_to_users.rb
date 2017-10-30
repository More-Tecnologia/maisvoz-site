class AddBuyFlagsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bought_adhesion, :boolean, default: false, null: false
    add_column :users, :bought_product, :boolean, default: false, null: false
  end
end
