class CreateCareerHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :career_histories do |t|
      t.references :user, foreign_key: true
      t.string :old_career
      t.string :new_career

      t.timestamps
    end
  end
end
