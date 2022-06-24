# frozen_string_literal: true

class AddPromotionalBalanceToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :promotional_balance, :decimal, default: 0
  end
end
