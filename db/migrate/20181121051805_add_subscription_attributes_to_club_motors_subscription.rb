class AddSubscriptionAttributesToClubMotorsSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :club_motors_subscriptions, :status, :string
    add_column :club_motors_subscriptions, :type, :string
    add_column :club_motors_subscriptions, :approved_by_username, :string
    add_column :club_motors_subscriptions, :current_period_start, :datetime
    add_column :club_motors_subscriptions, :current_period_end, :datetime
    add_column :club_motors_subscriptions, :activated_at, :datetime
  end
end
