class CreateUserCourse < ActiveRecord::Migration[5.2]
  def change
    create_table :user_courses do |t|
      t.boolean :active, default: false
      t.boolean :filed, default: false
      t.boolean :complete, default: false
      t.boolean :on_wishlist, default: false
      t.references :course
      t.references :user
    end
  end
end
