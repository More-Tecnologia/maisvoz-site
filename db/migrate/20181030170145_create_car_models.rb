class CreateCarModels < ActiveRecord::Migration[5.1]
  def change
    create_table :car_models do |t|
      t.integer :model_code
      t.integer :brand_code
      t.string :fipe_code
      t.string :name
      t.integer :type
      t.references :club_motors_fee, foreign_key: true

      t.timestamps
    end
    add_index :car_models, :brand_code
    add_foreign_key :car_models, :car_brands, column: :brand_code, primary_key: :brand_code
  end
end
