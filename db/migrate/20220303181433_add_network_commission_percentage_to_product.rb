class AddNetworkCommissionPercentageToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :network_commission_percentage, :decimal, default: 50.0
  end
end
