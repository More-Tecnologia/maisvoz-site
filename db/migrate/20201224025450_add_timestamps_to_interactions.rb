class AddTimestampsToInteractions < ActiveRecord::Migration[5.2]
  def change
    add_column :interactions, :created_at, :datetime
    add_column :interactions, :updated_at, :datetime
  end
end
