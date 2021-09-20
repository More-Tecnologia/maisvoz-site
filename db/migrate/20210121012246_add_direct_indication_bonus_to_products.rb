class AddDirectIndicationBonusToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :direct_indication_bonus, :float, default: 0.0
  end
end
