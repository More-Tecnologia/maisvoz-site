class AddDrIntegrationToClubmotors < ActiveRecord::Migration[5.1]
  def change
    add_column :club_motors_subscriptions, :dr_response, :jsonb
    add_column :club_motors_subscriptions, :dr_recorded, :boolean, default: false
  end
end
