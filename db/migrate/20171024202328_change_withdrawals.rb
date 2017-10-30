class ChangeWithdrawals < ActiveRecord::Migration[5.1]
  def up
    change_column :withdrawals, :status, :string, null: false
    add_column :withdrawals, :gross_amount_cents, :bigint, null: false
    add_column :withdrawals, :net_amount_cents, :bigint, null: false
    remove_column :withdrawals, :amount_cents
    add_index :withdrawals, :status
  end

  def down
    remove_columns :withdrawals, :gross_amount_cents, :net_amount_cents, :status
    add_column :withdrawals, :status, :integer, null: false
    add_column :withdrawals, :amount_cents, :bigint, null: false
  end
end
