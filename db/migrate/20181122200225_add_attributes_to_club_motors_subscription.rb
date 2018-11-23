class AddAttributesToClubMotorsSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :club_motors_subscriptions, :balance_cents, :bigint, null: false, default: 0
    add_column :club_motors_subscriptions, :billing_day_of_month, :integer
    add_column :club_motors_subscriptions, :current_billing_cycle, :integer, null: false, default: 0
    add_column :club_motors_subscriptions, :next_billing_date, :date
    add_column :club_motors_subscriptions, :price_cents, :bigint, null: false, default: 0
  end
end
