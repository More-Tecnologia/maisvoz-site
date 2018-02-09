class ChangeAmountInPvActivityHistory < ActiveRecord::Migration[5.1]
  def change
    rename_column :pv_activity_histories, :amount_cents, :amount
    change_column :pv_activity_histories, :amount, :integer
  end
end
