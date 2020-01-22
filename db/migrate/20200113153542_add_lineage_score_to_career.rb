class AddLineageScoreToCareer < ActiveRecord::Migration[5.2]
  def change
    add_column :careers, :lineage_score, :integer, default: 0
  end
end
