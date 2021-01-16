class CreateProductDescription < ActiveRecord::Migration[5.2]
  def change
    create_table :product_descriptions do |t|
      t.boolean :active
      t.text :description
      t.integer :position
      t.references :product, foreign_key: true
    end
  end
end
