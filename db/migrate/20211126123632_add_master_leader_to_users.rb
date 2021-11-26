class AddMasterLeaderToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :master_leader, :boolean, default: false
  end
end
