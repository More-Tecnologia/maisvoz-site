class RemoveActiveActiveUntilQualifiedCareerIdFromBinaryNodes < ActiveRecord::Migration[5.1]

  def change
    remove_column :binary_nodes, :active, :boolean
    remove_column :binary_nodes, :active_until, :date
    remove_column :binary_nodes, :qualified, :boolean
    remove_reference :binary_nodes, :career, index: true
  end

end
