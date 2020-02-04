class AddWalletAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :wallet_address, :string
  end
end
