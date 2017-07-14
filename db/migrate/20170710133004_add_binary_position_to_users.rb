class AddBinaryPositionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :binary_position, :integer
  end
end
