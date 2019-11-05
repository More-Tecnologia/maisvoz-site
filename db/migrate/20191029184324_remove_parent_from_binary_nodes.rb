class RemoveParentFromBinaryNodes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :binary_nodes, :parent
  end
end
