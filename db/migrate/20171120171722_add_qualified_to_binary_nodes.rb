class AddQualifiedToBinaryNodes < ActiveRecord::Migration[5.1]
  def change
    add_column :binary_nodes, :qualified, :boolean, default: false, null: false
  end
end
