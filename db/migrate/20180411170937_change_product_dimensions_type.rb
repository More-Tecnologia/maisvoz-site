class ChangeProductDimensionsType < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :length, :decimal, precision: 10, scale: 2
    change_column :products, :width, :decimal, precision: 10, scale: 2
    change_column :products, :height, :decimal, precision: 10, scale: 2
  end
end
