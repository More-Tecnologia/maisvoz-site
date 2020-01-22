class AddWithdrawalOrderAmountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :withdrawal_order_amount, :bigint, default: 0
  end
end
