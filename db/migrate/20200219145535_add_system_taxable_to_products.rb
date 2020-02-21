class AddSystemTaxableToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :system_taxable, :boolean, default: false
  end
end
