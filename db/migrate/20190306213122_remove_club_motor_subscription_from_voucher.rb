class RemoveClubMotorSubscriptionFromVoucher < ActiveRecord::Migration[5.1]
  def change
    remove_column :vouchers, :club_motors_subscription_id
  end
end
