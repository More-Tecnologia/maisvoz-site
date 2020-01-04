class AddActiveToScoreType < ActiveRecord::Migration[5.2]
  def change
    add_column :score_types, :active, :boolean, default: true
  end
end
