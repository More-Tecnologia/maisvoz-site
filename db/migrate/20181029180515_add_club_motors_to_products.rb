class AddClubMotorsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :club_motors, :boolean, null: false, default: false
  end
end
