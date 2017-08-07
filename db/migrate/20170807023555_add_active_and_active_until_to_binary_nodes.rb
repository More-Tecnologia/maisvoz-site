class AddActiveAndActiveUntilToBinaryNodes < ActiveRecord::Migration[5.1]
  def change
    add_column :binary_nodes, :active, :boolean, default: true, null: false
    add_column :binary_nodes, :active_until, :date
  end
end
