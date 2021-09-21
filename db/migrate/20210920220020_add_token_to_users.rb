class AddTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :token, :string, index: true
    add_index :users, :token
  end
end
