class AddExpireAtToScores < ActiveRecord::Migration[5.2]
  def change
    add_column :scores, :expire_at, :timestamp
  end
end
