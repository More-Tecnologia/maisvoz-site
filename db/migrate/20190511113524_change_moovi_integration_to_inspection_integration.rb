class ChangeMooviIntegrationToInspectionIntegration < ActiveRecord::Migration[5.2]
  def change
    rename_table :moovi_integrations, :inspection_integrations
  end
end
