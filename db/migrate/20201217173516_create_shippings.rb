class CreateShippings < ActiveRecord::Migration[5.2]
  def change
    create_table :shippings do |t|
      t.references :product, foreign_key: true
      t.string :country
      t.decimal :amount, default: 0

      t.timestamps
    end
  end
end
