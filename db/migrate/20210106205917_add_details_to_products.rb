class AddDetailsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :details, :text
  end
end
