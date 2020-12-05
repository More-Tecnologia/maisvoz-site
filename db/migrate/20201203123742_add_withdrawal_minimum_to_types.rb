class AddWithdrawalMinimumToTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :types, :withdrawal_minimum, :decimal, default: 0
    add_column :types, :withdrawal_in_percent, :boolean, default: false
  end
end
