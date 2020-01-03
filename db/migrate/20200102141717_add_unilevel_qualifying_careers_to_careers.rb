class AddUnilevelQualifyingCareersToCareers < ActiveRecord::Migration[5.2]
  def change
    add_column :careers, :unilevel_qualifying_career_id, :bigint, foreign_key: true
    add_index :careers, :unilevel_qualifying_career_id
    add_column :careers, :unilevel_qualifying_career_count, :integer, default: 0
  end
end
