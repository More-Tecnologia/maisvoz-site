class AddEnabledBonificationToBonusContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :bonus_contracts, :enabled_bonification, :boolean, default: true
  end
end
