class AddAncestryToBinaryNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :binary_nodes, :ancestry, :string
    add_index :binary_nodes, :ancestry
  end
end
