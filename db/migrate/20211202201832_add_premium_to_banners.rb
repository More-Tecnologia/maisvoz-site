class AddPremiumToBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :banners, :premium, :boolean, default: false
  end
end
