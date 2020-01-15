class AddDefaultStatusToWithdrawals < ActiveRecord::Migration[5.2]
  def change
    remove_column :withdrawals, :status
    add_column :withdrawals, :status, :integer, default: 0
  end
end
