# frozen_string_literal: true

class AddRaffleLicenseNumberToSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :system_configurations, :raffle_license_number, :string, default: ''
  end
end
