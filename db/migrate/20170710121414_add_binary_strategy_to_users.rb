class AddBinaryStrategyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :binary_strategy, :integer, default: 0
  end
end
