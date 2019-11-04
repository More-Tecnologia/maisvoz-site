class AddMonthlyMaximumBinaryScoreToCareer < ActiveRecord::Migration[5.2]
  def change
    add_column :careers, :monthly_maximum_binary_score, :integer
  end
end
