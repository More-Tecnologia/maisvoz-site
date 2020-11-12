class AddBannersSeenAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :banners_seen_at, :date
  end
end
