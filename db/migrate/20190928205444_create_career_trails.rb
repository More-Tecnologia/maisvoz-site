class CreateCareerTrails < ActiveRecord::Migration[5.2]
  def change
    create_table :career_trails do |t|
      t.references :career, foreign_key: true
      t.references :trail, foreign_key: true

      t.timestamps
    end
  end
end
