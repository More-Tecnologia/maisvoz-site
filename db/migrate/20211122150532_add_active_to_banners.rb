class AddActiveToBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :banners, :active, :boolean, default: true
  end
end
