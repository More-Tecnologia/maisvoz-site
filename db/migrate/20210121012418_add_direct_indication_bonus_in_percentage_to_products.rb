class AddDirectIndicationBonusInPercentageToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :direct_indication_bonus_in_percentage, :boolean, default: false
  end
end
