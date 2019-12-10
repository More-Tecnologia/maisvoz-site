class ChangeAncestryToTextFromBinaryNode < ActiveRecord::Migration[5.2]
  def change
    change_column :binary_nodes, :ancestry, :text
  end
end
