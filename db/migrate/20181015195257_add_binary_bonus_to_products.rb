class AddBinaryBonusToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :binary_bonus, :decimal
  end
end
