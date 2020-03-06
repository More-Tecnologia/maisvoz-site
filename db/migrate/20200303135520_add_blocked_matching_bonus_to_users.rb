class AddBlockedMatchingBonusToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :blocked_matching_bonus_balance, :decimal, default: 0
  end
end
