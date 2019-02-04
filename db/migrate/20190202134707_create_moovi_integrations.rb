class CreateMooviIntegrations < ActiveRecord::Migration[5.1]
  def change
    create_table :moovi_integrations do |t|
      t.jsonb :payload
      t.references :club_motors_subscription, foreign_key: true
      t.string :placa
      t.string :status
      t.string :fipe_code
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
