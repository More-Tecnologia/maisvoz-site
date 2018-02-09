class AddCareerKindToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :career_kind, :string
    add_index :users, :career_kind
  end
end
