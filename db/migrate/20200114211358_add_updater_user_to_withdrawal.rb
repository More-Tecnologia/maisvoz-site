class AddUpdaterUserToWithdrawal < ActiveRecord::Migration[5.2]
  def change
    add_column :withdrawals, :updater_user_id, :bigint, foreign_key: true
    add_index :withdrawals, :updater_user_id
  end
end
