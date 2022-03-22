# frozen_string_literal: true
class AddClicksToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :clicks, :integer, default: 0
  end
end
  