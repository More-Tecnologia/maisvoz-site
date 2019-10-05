class AddDefaultValueToProductScores < ActiveRecord::Migration[5.2]
  def change
    change_column :product_scores, :fix_value, :boolean, default: false
  end
end
