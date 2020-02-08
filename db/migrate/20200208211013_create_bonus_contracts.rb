class CreateBonusContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :bonus_contracts do |t|
      t.references :user
      t.datetime :paid_at
      t.datetime :expire_at
      t.integer :cent_amount
      t.references :order
      t.bigint :received_balance
      t.bigint :remaining_balance

      t.timestamps
    end
  end
end
