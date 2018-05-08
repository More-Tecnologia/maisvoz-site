class CreateProductSetups < ActiveRecord::Migration[5.1]
  def change
    create_table :product_setups do |t|
      t.references :installer, index: true, foreign_key: { to_table: :users }
      t.string :name
      t.string :document_cpf
      t.string :phone
      t.string :email
      t.string :car_brand
      t.string :car_year
      t.string :car_model
      t.string :car_mileage
      t.string :car_plate
      t.string :product_model
      t.string :product_serial
      t.string :status
      t.string :status_message
      t.datetime :status_updated_at

      t.timestamps
    end
  end
end
