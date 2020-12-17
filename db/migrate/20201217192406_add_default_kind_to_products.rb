class AddDefaultKindToProducts < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :kind, :integer, default: 0
  end
end
