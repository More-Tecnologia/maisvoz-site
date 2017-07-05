class CreateAccounts < ActiveRecord::Migration[5.1]

  def change
    create_table :accounts do |t|
      t.bigint :available_balance_cents, default: 0, null: false
      t.bigint :blocked_balance_cents, default: 0, null: false
      t.references :user, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end

end
