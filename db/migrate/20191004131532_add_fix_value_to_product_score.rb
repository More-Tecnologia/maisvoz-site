class AddFixValueToProductScore < ActiveRecord::Migration[5.2]
  def change
    add_column :product_scores, :fix_value, :boolean
  end
end
