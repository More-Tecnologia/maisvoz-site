class AddBalanceTransferenceToType < ActiveRecord::Migration[5.2]
  def change
    add_column :types, :balance_transference, :boolean, default: false
  end
end
