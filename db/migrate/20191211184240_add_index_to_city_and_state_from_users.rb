class AddIndexToCityAndStateFromUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :city
    add_index :users, :state
  end
end
