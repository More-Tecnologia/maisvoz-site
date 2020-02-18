class CreateDigitalWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :digital_wallets do |t|
      t.string :address
      t.integer :status, default: 0
      t.references :user

      t.timestamps
    end
  end
end
