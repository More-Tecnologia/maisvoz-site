class ChangeCentAmountTypeFromScore < ActiveRecord::Migration[5.2]
  def change
    change_column :scores, :cent_amount, :bigint
  end
end
