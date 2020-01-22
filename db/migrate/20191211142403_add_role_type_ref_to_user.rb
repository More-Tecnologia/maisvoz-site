class AddRoleTypeRefToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role_type_code, :bigint, foreign_key: true
    add_index :users, :role_type_code
  end
end
