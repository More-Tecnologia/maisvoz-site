class AddWalletToWithdrawal < ActiveRecord::Migration[5.2]
  def change
    add_column :withdrawals, :wallet, :string, default: ''
  end
end
