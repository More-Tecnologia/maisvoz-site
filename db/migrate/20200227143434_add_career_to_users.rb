class AddCareerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :career, foreign_key: true
  end
end
