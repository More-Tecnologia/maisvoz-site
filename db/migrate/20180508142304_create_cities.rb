class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :state
      t.string :name
      t.integer :ibge

      t.timestamps
    end
  end
end
