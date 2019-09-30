class CreateTrailProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :trail_products do |t|
      t.references :trail, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
