class AddReputationToSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :system_configurations, :reputation, :boolean, default: true
  end
end
