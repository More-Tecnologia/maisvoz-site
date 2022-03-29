# frozen_string_literal: true

class AddOrderReferenceToBanners < ActiveRecord::Migration[5.2]
  def change
    add_reference :banners, :order, foreign_key: true      
  end
end