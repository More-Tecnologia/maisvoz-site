class RemoveSapCodeFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :sap_code
  end
end
