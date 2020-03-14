class AddGeneratePoolPointsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :generate_pool_points, :boolean, default: false
  end
end
