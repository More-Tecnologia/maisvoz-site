class AddTransferenceBalanceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :transference_balance, :decimal, default: 0
  end
end
