class CreateRoleTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :role_types do |t|
      t.string :name
      t.bigint :code

      t.timestamps
    end
  end
end
