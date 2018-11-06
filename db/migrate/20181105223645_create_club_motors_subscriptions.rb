class CreateClubMotorsSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :club_motors_subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :car_model, foreign_key: true
      t.string :chassis
      t.string :plate
      t.string :cnpj_cpf
      t.string :owner_name
      t.string :manufacture_year
      t.string :model_year
      t.string :fuel
      t.integer :mileage
      t.string :renavam
      t.string :gearbox
      t.boolean :taxi
      t.string :mercosul_code
      t.string :color
      t.string :color_type
      t.string :origin

      t.timestamps
    end
  end
end
