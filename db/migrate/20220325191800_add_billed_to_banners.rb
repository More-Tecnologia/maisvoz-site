# frozen_string_literal: true

class AddBilledToBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :banners, :billed, :boolean, default: false
  end
end
