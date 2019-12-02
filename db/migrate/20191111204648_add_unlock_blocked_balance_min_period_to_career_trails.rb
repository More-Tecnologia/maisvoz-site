class AddUnlockBlockedBalanceMinPeriodToCareerTrails < ActiveRecord::Migration[5.2]
  def change
    add_column :career_trails, :unlock_blocked_balance_min_period, :integer, default: 0
  end
end
