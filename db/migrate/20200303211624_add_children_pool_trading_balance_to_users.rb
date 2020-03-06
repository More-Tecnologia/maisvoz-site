class AddChildrenPoolTradingBalanceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :children_pool_trading_balance, :decimal, default: 0
  end
end
