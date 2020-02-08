class CreateBonusContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :bonus_contracts do |t|
      t.references :user
      t.datetime :paid_at
      t.datetime :expire_at
      t.bigint :cent_amount, default: 0
      t.references :order
      t.bigint :received_balance, default: 0
      t.bigint :remaining_balance, default: 0

      t.timestamps
    end
  end
end
