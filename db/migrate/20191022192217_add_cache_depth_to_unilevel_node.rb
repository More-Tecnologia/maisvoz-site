class AddCacheDepthToUnilevelNode < ActiveRecord::Migration[5.2]
  def change
    add_column :unilevel_nodes, :ancestry_depth, :integer, default: 0
  end
end
