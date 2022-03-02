class AddExpenseCentAmountToSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :system_configurations, :expense_cent_amount, :integer, default: 0
  end
end
