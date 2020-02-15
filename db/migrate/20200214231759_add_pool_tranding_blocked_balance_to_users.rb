class AddPoolTrandingBlockedBalanceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pool_tranding_blocked_balance, :bigint, default: 0
  end
end
