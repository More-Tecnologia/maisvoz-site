class AddCodeToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :code, :integer
  end
end
