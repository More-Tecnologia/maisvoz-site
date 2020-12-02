class AddTypeRefToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :type, foreign_key: true
  end
end
