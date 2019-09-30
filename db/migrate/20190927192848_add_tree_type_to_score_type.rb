class AddTreeTypeToScoreType < ActiveRecord::Migration[5.2]
  def change
    add_column :score_types, :tree_type, :integer, default: 0
  end
end
