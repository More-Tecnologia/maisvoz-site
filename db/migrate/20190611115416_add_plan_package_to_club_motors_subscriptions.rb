class AddPlanPackageToClubMotorsSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :club_motors_subscriptions, :plan_package, :string
  end
end
