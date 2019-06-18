class AddAssistance24hToClubMotorsSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :club_motors_subscriptions, :assistance_24h, :boolean, default: false
  end
end
