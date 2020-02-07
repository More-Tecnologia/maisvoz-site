class AddBinaryFestToScores < ActiveRecord::Migration[5.2]
  def change
    add_column :scores, :binary_fest, :boolean, default: false
  end
end
