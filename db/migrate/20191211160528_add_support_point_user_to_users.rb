class AddSupportPointUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :support_point_user_id, :bigint, foreign_key: true
    add_index :users, :support_point_user_id
  end
end
