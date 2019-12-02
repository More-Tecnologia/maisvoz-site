class ChangeAncestrySizeInUnilevelNode < ActiveRecord::Migration[5.2]
  def change
    change_column :unilevel_nodes, :ancestry, :text
  end
end
