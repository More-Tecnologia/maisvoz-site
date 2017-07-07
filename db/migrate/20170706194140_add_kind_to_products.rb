class AddKindToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :kind, :integer
  end
end
