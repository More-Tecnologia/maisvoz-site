class AddBinaryFestToBinaryNode < ActiveRecord::Migration[5.2]
  def change
    add_column :binary_nodes, :binary_fest, :boolean, default: false
  end
end
