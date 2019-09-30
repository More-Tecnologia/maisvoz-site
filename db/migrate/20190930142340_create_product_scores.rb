class CreateProductScores < ActiveRecord::Migration[5.2]
  def change
    create_table :product_scores do |t|
      t.references :career, foreign_key: true
      t.references :product, foreign_key: true
      t.references :trail, foreign_key: true
      t.integer :receiving_maximum_generation
      t.integer :cent_amount

      t.timestamps
    end
  end
end
