class ChangeCarPlateLimit < ActiveRecord::Migration[5.1]
  def up
    change_column :product_setups, :car_plate, :string, limit: 7
    add_index :product_setups, :car_plate, unique: true
  end
  def down
    change_column :product_setups, :car_plate, :string, limit: 255
    remove_index :product_setups, :car_plate
  end
end
