class ChangeProductQuantityToString < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :quantity, :string
  end
end
