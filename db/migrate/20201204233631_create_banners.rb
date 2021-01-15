class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.text :link
      t.string :image_path

      t.timestamps
    end
  end
end
