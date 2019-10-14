class CreateCareerTrailUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :career_trail_users do |t|
      t.references :career_trail, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
