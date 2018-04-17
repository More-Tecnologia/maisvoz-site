class DropCloudinaryImages < ActiveRecord::Migration[5.1]
  def change
    drop_table :cloudinary_images
  end
end
