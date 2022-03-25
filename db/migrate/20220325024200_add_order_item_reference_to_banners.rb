# frozen_string_literal: true

class AddOrderItemReferenceToBanners < ActiveRecord::Migration[5.2]
  def change
    add_reference :banners, :order_item, foreign_key: true
  end
end
