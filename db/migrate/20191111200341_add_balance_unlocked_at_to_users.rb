class AddBalanceUnlockedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :balance_unlocked_at, :datetime
  end
end
