class RemoveProductRefFromProductScore < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_scores, :product_id
  end
end
