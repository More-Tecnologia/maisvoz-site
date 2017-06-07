class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :short_description
      t.string :sku, limit: 10
      t.integer :quantity
      t.integer :low_stock_alert
      t.decimal :weight, precision: 10, scale: 2
      t.integer :length
      t.integer :width
      t.integer :height
      t.bigint :price_cents
      t.integer :binary_score
      t.integer :advance_score
      t.boolean :active
      t.boolean :virtual
      t.integer :paid_by
      t.references :category, foreign_key: true
      t.references :career, foreign_key: true
      t.integer :bonus_1
      t.integer :bonus_2
      t.integer :bonus_3
      t.integer :bonus_4
      t.integer :bonus_5
      t.integer :bonus_6
      t.integer :bonus_7
      t.integer :bonus_8
      t.integer :bonus_9

      t.timestamps
    end
  end
end
