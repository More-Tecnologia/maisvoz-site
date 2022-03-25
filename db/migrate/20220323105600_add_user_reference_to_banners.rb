# frozen_string_literal: true

class AddUserReferenceToBanners < ActiveRecord::Migration[5.2]
  def change
    add_reference :banners, :user, foreign_key: true      
  end
end