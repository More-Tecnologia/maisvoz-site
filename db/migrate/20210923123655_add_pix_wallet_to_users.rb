class AddPixWalletToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pix_wallet, :string
  end
end
