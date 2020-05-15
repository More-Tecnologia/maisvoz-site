class AddRentabilityToBonusContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :bonus_contracts, :rentability, :decimal, default: 0
  end
end
