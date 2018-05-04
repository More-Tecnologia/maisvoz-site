class AddSapRecordedToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :sap_recorded, :boolean, default: false
  end
end
