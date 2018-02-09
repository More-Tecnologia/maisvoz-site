class AddPvaTotalToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pva_total, :bigint, null: false, default: 0
  end
end
