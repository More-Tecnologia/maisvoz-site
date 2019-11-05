class AddScoreToScores < ActiveRecord::Migration[5.2]
  def change
    add_reference :scores, :score, foreign_key: true
  end
end
