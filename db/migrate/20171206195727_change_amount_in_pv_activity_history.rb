class ChangeAmountInPvActivityHistory < ActiveRecord::Migration[5.1]
  def up
    rename_column :pv_activity_histories, :amount_cents, :amount
    change_column :pv_activity_histories, :amount, :integer
  end

  def down
    rename_column :pv_activity_histories, :amount, :amount_cents
    change_column :pv_activity_histories, :amount_cents, :bigint
  end
end
