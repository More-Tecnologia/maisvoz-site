class CreatePoolWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :pool_wallets do |t|
      t.string :title, null: false, index: true
      t.string :wallet, null: false
      t.integer :cent_amount, default: 0

      t.timestamps
    end
  end
end
