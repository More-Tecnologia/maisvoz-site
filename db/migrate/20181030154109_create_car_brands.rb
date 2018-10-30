class CreateCarBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :car_brands do |t|
      t.integer :brand_code, null: false
      t.string :name
      t.integer :type

      t.timestamps
    end
    add_index :car_brands, :brand_code, unique: true
  end
end
