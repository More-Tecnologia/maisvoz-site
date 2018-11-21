class ChangeClubmotorsSubscriptionPeriodType < ActiveRecord::Migration[5.1]
  def change
    change_column :club_motors_subscriptions, :current_period_start, :date
    change_column :club_motors_subscriptions, :current_period_end, :date
  end
end
