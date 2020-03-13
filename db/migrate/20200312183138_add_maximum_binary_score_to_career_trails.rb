class AddMaximumBinaryScoreToCareerTrails < ActiveRecord::Migration[5.2]
  def change
    add_column :career_trails, :maximum_binary_score, :integer
  end
end
