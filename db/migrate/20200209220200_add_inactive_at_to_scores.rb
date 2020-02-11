class AddInactiveAtToScores < ActiveRecord::Migration[5.2]
  def change
    add_column :scores, :inactive_at, :datetime
  end
end
