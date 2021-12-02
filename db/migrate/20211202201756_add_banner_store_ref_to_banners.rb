class AddBannerStoreRefToBanners < ActiveRecord::Migration[5.2]
  def change
    add_reference :banners, :banner_store, foreign_key: true
  end
end
