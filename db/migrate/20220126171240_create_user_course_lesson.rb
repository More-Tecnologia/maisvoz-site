class CreateUserCourse < ActiveRecord::Migration[5.2]
  def change
    create_table :user_course_lessons do |t|
      t.boolean :complete, default: false
      t.references :course_lesson
      t.references :user_course
    end
  end
end
