class AddMaximumBonusToCareerTrails < ActiveRecord::Migration[5.2]
  def change
    add_column :career_trails, :maximum_bonus, :integer
  end
end
