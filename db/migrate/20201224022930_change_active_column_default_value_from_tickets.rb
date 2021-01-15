class ChangeActiveColumnDefaultValueFromTickets < ActiveRecord::Migration[5.2]
  def change
    change_column :tickets, :active, :boolean, default: true
  end
end
