# frozen_string_literal: true
class AddDetailsToBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :banners, :country_of_operation, :string, array: true,  default: [], null: false
    add_column :banners, :title, :string, default: '', null: false
    add_column :banners, :description, :text, default: '', null: false
    add_column :banners, :status, :integer, default: 0
    add_column :banners, :views, :integer, default: 0
    add_column :banners, :current_clicks, :integer, default: 0
  end
end
  