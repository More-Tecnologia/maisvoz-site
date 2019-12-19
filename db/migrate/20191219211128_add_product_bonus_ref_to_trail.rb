class AddProductBonusRefToTrail < ActiveRecord::Migration[5.2]
  def change
    add_column :trails, :product_bonus_id, :bigint, foreign_key: true
  end
end
