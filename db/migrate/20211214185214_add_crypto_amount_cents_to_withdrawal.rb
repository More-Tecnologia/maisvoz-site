class AddCryptoAmountCentsToWithdrawal < ActiveRecord::Migration[5.2]
  def change
    add_column :withdrawals, :crypto_amount, :bigint, default: 0
  end
end
