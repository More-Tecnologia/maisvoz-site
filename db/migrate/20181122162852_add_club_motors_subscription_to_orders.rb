class AddClubMotorsSubscriptionToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :club_motors_subscription, foreign_key: true
  end
end