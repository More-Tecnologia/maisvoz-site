class AddSapCodeToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :sap_code, :string
    add_index :products, :sap_code, unique: true
  end
end
