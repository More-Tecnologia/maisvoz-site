class AddTaskPerDayToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :task_per_day, :integer
  end
end
