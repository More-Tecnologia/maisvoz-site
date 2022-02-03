class CreateCourseLesson < ActiveRecord::Migration[5.2]
  def change
    create_table :course_lessons do |t|
      t.boolean :active, default: true
      t.boolean :preview, default: false
      t.string :title, null: false
      t.string :link, null: false
      t.string :description, null: false
      t.references :course
    end
  end
end
