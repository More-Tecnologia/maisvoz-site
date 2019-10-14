class AddKindToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :type, :integer
  end
end
