class AddWeeklyMaximumBinaryScoreToCareer < ActiveRecord::Migration[5.2]
  def change
    add_column :careers, :weekly_maximum_binary_score, :integer
  end
end
