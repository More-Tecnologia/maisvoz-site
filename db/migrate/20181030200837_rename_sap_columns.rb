class RenameSapColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :sap_recorded, :dr_recorded
    rename_column :orders, :sap_response, :dr_response
  end
end
