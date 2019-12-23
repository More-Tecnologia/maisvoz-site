class AddUnlockBlockedBalanceThresholdToCareerTrails < ActiveRecord::Migration[5.2]
  def change
    add_column :career_trails, :unlock_blocked_balance_threshold, :bigint
  end
end
