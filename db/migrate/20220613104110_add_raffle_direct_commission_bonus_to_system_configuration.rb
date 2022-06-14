# frozen_string_literal: true

class AddRaffleDirectCommissionBonusToSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :system_configurations, :raffles_direct_commission_bonus, :float, default: 0.0
  end
end
