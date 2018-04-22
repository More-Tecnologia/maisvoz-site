class RemoveVerifiedFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :verified
  end
end
