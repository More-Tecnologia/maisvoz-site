class ChangeUserEnumColumns < ActiveRecord::Migration[5.1]

  def up
    change_column :users, :role, :string, default: 'consumidor', null: false
    change_column :users, :binary_strategy, :string, default: 'balanced_strategy', null: false
    change_column :users, :binary_position, :string
  end

end
