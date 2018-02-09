class AddActiveActiveUntilBinaryQualifiedToUsers < ActiveRecord::Migration[5.1]

  def change
    add_column :users, :active, :boolean, null: false, default: false
    add_column :users, :active_until, :date
    add_column :users, :binary_qualified, :boolean, null: false, default: false
  end

end
