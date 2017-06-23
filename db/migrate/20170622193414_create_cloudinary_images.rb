class CreateCloudinaryImages < ActiveRecord::Migration[5.1]
  def change
    create_table :cloudinary_images do |t|
      t.string :public_id
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
