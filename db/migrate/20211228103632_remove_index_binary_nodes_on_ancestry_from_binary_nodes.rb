class RemoveIndexBinaryNodesOnAncestryFromBinaryNodes < ActiveRecord::Migration[5.2]
  def change
    remove_index :binary_nodes, :ancestry
  end
end
