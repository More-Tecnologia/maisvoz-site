class AddAscendantSponsorsIdsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ascendant_sponsors_ids, :text
  end
end
