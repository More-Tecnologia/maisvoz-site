class AddDetailsToBanners < ActiveRecord::Migration[5.2]
    def change
      add_column :banners, :country_of_operation, :string, array: true,  default: []
      add_column :banners, :title, :string
      add_column :banners, :description, :string
      add_column :banners, :status, :string
      add_column :banners, :views, :integer
      add_column :banners, :current_clicks, :integer
    end
  end
  